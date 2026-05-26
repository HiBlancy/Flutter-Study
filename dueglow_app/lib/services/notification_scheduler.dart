import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../models/beauty_product.dart';
import '../models/routine_model.dart';
import 'notification_messages.dart';
import 'notification_service.dart';
import 'notification_preferences_service.dart';
import 'product_service.dart';
import 'routine_service.dart';

/// Plans local notifications from current products and routines.
class NotificationScheduler {
  NotificationScheduler._();
  static final NotificationScheduler instance = NotificationScheduler._();

  static const int _expirationIdBase = 10000;
  static const int _routineId = 50000;
  static const int _weeklyDigestId = 60000;

  final ProductService _productService = ProductService();
  final RoutineService _routineService = RoutineService();
  final NotificationPreferencesService _prefs = NotificationPreferencesService();

  Future<void> syncAll() async {
    await NotificationService.instance.initialize();
    await NotificationService.instance.cancelAll();

    final settings = await _prefs.load();
    if (!settings.masterEnabled) return;

    final locale = await _prefs.getLocaleCode();

    if (settings.expirationEnabled) {
      await _scheduleExpirationReminders(locale);
    }
    if (settings.routinesEnabled) {
      await _scheduleNextRoutine(locale);
    }
    if (settings.weeklyDigestEnabled) {
      await _scheduleWeeklyDigest(locale);
    }
  }

  Future<void> _scheduleExpirationReminders(String locale) async {
    final products = await _fetchHaveProducts();
    final now = DateTime.now();

    for (final product in products) {
      final expiration = product.expirationDate;
      final id = product.id;
      if (expiration == null || id == null || id.isEmpty) continue;

      final expDay = DateTime(
        expiration.year,
        expiration.month,
        expiration.day,
      );

      for (var i = 0; i < AppConstants.expirationReminderDays.length; i++) {
        final daysBefore = AppConstants.expirationReminderDays[i];
        final triggerDay = expDay.subtract(Duration(days: daysBefore));
        await _scheduleExpirationAlert(
          locale: locale,
          product: product,
          productId: id,
          milestoneIndex: i,
          daysLeft: daysBefore,
          when: DateTime(triggerDay.year, triggerDay.month, triggerDay.day, 9, 30),
          now: now,
        );
      }

      // "Caducado": día siguiente a la fecha de caducidad.
      final expiredNoticeDay = expDay.add(const Duration(days: 1));
      await _scheduleExpirationAlert(
        locale: locale,
        product: product,
        productId: id,
        milestoneIndex: 7,
        daysLeft: -1,
        when: DateTime(
          expiredNoticeDay.year,
          expiredNoticeDay.month,
          expiredNoticeDay.day,
          9,
          30,
        ),
        now: now,
      );
    }
  }

  Future<void> _scheduleExpirationAlert({
    required String locale,
    required BeautyProduct product,
    required String productId,
    required int milestoneIndex,
    required int daysLeft,
    required DateTime when,
    required DateTime now,
  }) async {
    if (!when.isAfter(now)) return;

    await NotificationService.instance.schedule(
      id: _expirationNotificationId(productId, milestoneIndex),
      title: NotificationMessages.expirationTitle(locale, daysLeft),
      body: NotificationMessages.expirationBody(locale, product.name, daysLeft),
      when: when,
    );
  }

  Future<void> _scheduleNextRoutine(String locale) async {
    List<Routine> routines;
    try {
      routines = await _routineService.getRoutines();
    } catch (e) {
      if (kDebugMode) debugPrint('NotificationScheduler routines: $e');
      return;
    }

    final next = _findNextRoutineSlot(routines);
    if (next == null) return;

    await NotificationService.instance.schedule(
      id: _routineId,
      title: NotificationMessages.routineTitle(locale),
      body: NotificationMessages.routineBody(
        locale,
        next.routine.name,
        next.routine.type == RoutineType.morning,
      ),
      when: next.when,
    );
  }

  Future<void> _scheduleWeeklyDigest(String locale) async {
    final expiring = await _productService.getExpiringSoon(days: 30);
    final count = expiring.length;
    if (count == 0) return;

    final when = _nextSundayMorning();
    await NotificationService.instance.schedule(
      id: _weeklyDigestId,
      title: NotificationMessages.weeklyTitle(locale),
      body: NotificationMessages.weeklyBody(locale, count),
      when: when,
    );
  }

  Future<List<BeautyProduct>> _fetchHaveProducts() async {
    final all = <BeautyProduct>[];
    var page = 1;
    const limit = 50;

    while (true) {
      final batch = await _productService.getProducts(
        listType: 'have',
        page: page,
        limit: limit,
      );
      if (batch == null || batch.products.isEmpty) break;
      all.addAll(batch.products);
      if (page >= batch.totalPages) break;
      page++;
    }
    return all;
  }

  _RoutineSlot? _findNextRoutineSlot(List<Routine> routines) {
    if (routines.isEmpty) return null;

    final now = DateTime.now();
    _RoutineSlot? best;

    for (var offset = 0; offset < 21; offset++) {
      final date = now.add(Duration(days: offset));
      final dayKey = _weekdayKey(date.weekday);

      for (final routine in routines) {
        if (!routine.days.contains(dayKey)) continue;

        final hour = routine.type == RoutineType.morning ? 8 : 20;
        final candidate = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
        );
        if (!candidate.isAfter(now)) continue;

        if (best == null || candidate.isBefore(best.when)) {
          best = _RoutineSlot(routine: routine, when: candidate);
        }
      }
    }
    return best;
  }

  DateTime _nextSundayMorning() {
    var cursor = DateTime.now();
    while (cursor.weekday != DateTime.sunday) {
      cursor = cursor.add(const Duration(days: 1));
    }
    var scheduled = DateTime(cursor.year, cursor.month, cursor.day, 10);
    if (!scheduled.isAfter(DateTime.now())) {
      scheduled = scheduled.add(const Duration(days: 7));
    }
    return scheduled;
  }

  String _weekdayKey(int weekday) {
    const keys = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return keys[weekday - 1];
  }

  int _expirationNotificationId(String productId, int milestoneIndex) {
    return _expirationIdBase +
        (productId.hashCode.abs() % 5000) * 10 +
        milestoneIndex;
  }
}

class _RoutineSlot {
  final Routine routine;
  final DateTime when;

  _RoutineSlot({required this.routine, required this.when});
}
