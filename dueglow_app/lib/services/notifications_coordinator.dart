import 'notification_scheduler.dart';

/// Entry point to refresh scheduled notifications after data changes.
class NotificationsCoordinator {
  NotificationsCoordinator._();

  static Future<void> refresh() => NotificationScheduler.instance.syncAll();
}
