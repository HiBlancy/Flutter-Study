import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/beauty_product.dart';
import '../models/routine_model.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../services/routine_service.dart';
import '../widgets/main_toolbar.dart';
import 'routine_detail.screen.dart';
import 'product_screen.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  final ProductService _productService = ProductService();
  final RoutineService _routineService = RoutineService();

  String _userName = '';
  bool _isLoading = true;
  List<BeautyProduct> _expiringSoonProducts = [];
  List<Routine> _routines = [];
  YearlyOverviewStats _yearlyOverview = YearlyOverviewStats.empty();
  CurrentMonthStats? _currentMonthStats;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final nameFuture = _authService.getUserName();
    final expiringProductsFuture = _productService.getExpiringSoon(days: 30);
    final routinesFuture = _routineService.getRoutines();
    final yearlyOverviewFuture = _productService.getYearlyOverview();
    final currentMonthStatsFuture = _productService.getCurrentMonthStats();
    final name = await nameFuture;
    final expiringProducts = await expiringProductsFuture;
    final yearlyOverview = await yearlyOverviewFuture;
    final currentMonthStats = await currentMonthStatsFuture;
    List<Routine> routines = [];
    try {
      routines = await routinesFuture;
    } catch (_) {
      routines = [];
    }

    if (mounted) {
      setState(() {
        _userName = name ?? AppLocalizations.of(context)!.defaultUserName;
        _expiringSoonProducts = expiringProducts;
        _routines = routines;
        _yearlyOverview = yearlyOverview;
        _currentMonthStats = currentMonthStats;
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadUserData();
  }

  Future<void> _navigateToProduct(BeautyProduct product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductScreen(product: product, isFromSearch: false),
      ),
    );
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return CustomAppBar(
      title: 'DueGlow',
      showDrawer: true,
      showBackButton: false,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreetingPrefix().toUpperCase(),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    letterSpacing: 2,
                                    color: isDark
                                        ? theme.colorScheme.primary.withValues(
                                            alpha: 0.8,
                                          )
                                        : theme.colorScheme.primary.withValues(
                                            alpha: 0.7,
                                          ),
                                    fontFamily: 'Sora',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.skinGlowTagline,
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                    color: theme.colorScheme.primary
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons
                                  .eco_outlined,
                              size: 80,
                              color: theme.colorScheme.surfaceTint.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildQuickActions(theme, isDark),
                    const SizedBox(height: 32),
                    _buildExpiringSoonProducts(isDark),
                    _buildMonthlyUsageSection(isDark),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }

  String _getGreetingPrefix() {
    final hour = DateTime.now().hour;
    final name = _userName;

    if (hour < 14) {
      return AppLocalizations.of(context)!.morningGreeting(name).toUpperCase();
    } else if (hour < 18) {
      return AppLocalizations.of(context)!.afternoonGreeting(name).toUpperCase();
    } else {
      return AppLocalizations.of(context)!.eveningGreeting(name).toUpperCase();
    }
  }

  Widget _buildQuickActions(
    ThemeData theme,
    bool isDark,
  ) {
    final color = isDark
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
        : theme.colorScheme.primaryContainer.withValues(alpha: 0.45);
    final nextRoutine = _findNextRoutine();
    final hasRoutine = nextRoutine != null;
    final routine = nextRoutine?.routine;
    final isMorningRoutine = routine?.type == RoutineType.morning;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        elevation: 0,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            if (!hasRoutine) {
              await Navigator.pushNamed(context, AppConstants.routeMyRoutines);
              await _loadUserData();
              return;
            }
            final changed = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => RoutineDetailScreen(routine: routine!),
              ),
            );
            if (changed == true) {
              await _loadUserData();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: hasRoutine
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isMorningRoutine
                              ? Icons.wb_sunny_outlined
                              : Icons.nights_stay_outlined,
                          color: theme.colorScheme.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.nextRoutineTitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              routine!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${nextRoutine.slotLabel} • ${AppLocalizations.of(context)!.routineProductsCount(routine.products.length)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.routinesTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.createFirstRoutineHomeHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  _UpcomingRoutineInfo? _findNextRoutine() {
    if (_routines.isEmpty) return null;

    final now = DateTime.now();
    final todayIndex = now.weekday - 1;
    final currentSlot = now.hour < 12 ? RoutineType.morning : RoutineType.night;

    for (var dayOffset = 0; dayOffset < 7; dayOffset++) {
      final dayIndex = (todayIndex + dayOffset) % 7;
      final dayKey = _dayKeyFromIndex(dayIndex);
      final slots = dayOffset == 0 && currentSlot == RoutineType.night
          ? [RoutineType.night]
          : [RoutineType.morning, RoutineType.night];

      for (final slot in slots) {
        final matches = _routines
            .where((r) => r.days.contains(dayKey) && r.type == slot)
            .toList();
        if (matches.isNotEmpty) {
          matches.sort((a, b) => a.name.compareTo(b.name));
          final selected = matches.first;
          return _UpcomingRoutineInfo(
            routine: selected,
            slotLabel: _buildSlotLabel(dayOffset, slot),
          );
        }
      }
    }

    return null;
  }

  String _dayKeyFromIndex(int dayIndex) {
    const dayKeys = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return dayKeys[dayIndex];
  }

  String _buildSlotLabel(int dayOffset, RoutineType slot) {
    final l10n = AppLocalizations.of(context)!;
    if (dayOffset == 0) {
      return slot == RoutineType.morning
          ? l10n.slotTodayMorning
          : l10n.slotTodayNight;
    }
    if (dayOffset == 1) {
      return slot == RoutineType.morning
          ? l10n.slotTomorrowMorning
          : l10n.slotTomorrowNight;
    }
    return slot == RoutineType.morning
        ? l10n.slotInDaysMorning(dayOffset)
        : l10n.slotInDaysNight(dayOffset);
  }

 Widget _buildExpiringSoonProducts(bool isDark) {
  final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context)!;

  final displayProducts = _expiringSoonProducts.take(6).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.expiringSoon,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.prioritizeExpiringHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)
                          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      if (_expiringSoonProducts.isEmpty)
        _buildEmptyCard(theme, l10n, isDark)
      else
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: displayProducts.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 160,
                child: _buildExpiringProductCardVertical(
                  displayProducts[index],
                  isDark,
                ),
              ),
            ),
          ),
        ),
      const SizedBox(height: 24),
    ],
  );
}

  Widget _buildMonthlyUsageSection(bool isDark) {
    final theme = Theme.of(context);
    final stats = _yearlyOverview.data;
    final latestSix = stats.length > 6 ? stats.sublist(stats.length - 6) : stats;
    final maxValue = latestSix.isEmpty
        ? 1
        : latestSix
            .map((item) => item.productsUsedCount)
            .reduce((a, b) => a > b ? a : b);
    final currentMonthCount = _currentMonthStats?.productsUsedCount ??
        (stats.isNotEmpty ? stats.last.productsUsedCount : 0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? theme.colorScheme.primary.withValues(alpha: 0.2)
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.monthlyUsageTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!.monthlyUsageDescription,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMetricChip(
                  icon: Icons.calendar_month_outlined,
                  label: AppLocalizations.of(context)!.thisMonthLabel,
                  value: '$currentMonthCount',
                  theme: theme,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildMetricChip(
                  icon: Icons.bar_chart_rounded,
                  label: AppLocalizations.of(context)!.twelveMonthsLabel,
                  value: '${_yearlyOverview.total}',
                  theme: theme,
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (latestSix.isEmpty)
              Text(
                AppLocalizations.of(context)!.noUsageHistory,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              SizedBox(
                height: 130,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: latestSix.map((item) {
                    final ratio = item.productsUsedCount / (maxValue == 0 ? 1 : maxValue);
                    final barHeight = 20 + (ratio * 70);
                    final shortMonth = item.monthName.length >= 3
                        ? item.monthName.substring(0, 3)
                        : item.monthName;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${item.productsUsedCount}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: barHeight,
                              width: 18,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: isDark ? 0.8 : 0.7,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              shortMonth,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(ThemeData theme, AppLocalizations l10n, bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: isDark
                ? theme.colorScheme.primary.withValues(alpha: 0.7)
                : theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.allFine,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noProdExpiring,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringProductCardVertical(BeautyProduct product, bool isDark) {
  final theme = Theme.of(context);
  final days = product.expirationDate!.difference(DateTime.now()).inDays;
  final isDanger = days <= 7;
  final l10n = AppLocalizations.of(context)!;

  final cardColor = isDark
      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
      : theme.colorScheme.primaryContainer.withValues(alpha: 0.2);

  return Card(
    elevation: 0,
    color: cardColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: InkWell(
      onTap: () => _navigateToProduct(product),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 100,
                width: double.infinity,
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.surfaceContainerLow,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Icon(
                        Icons.face_retouching_natural,
                        size: 40,
                        color: isDark
                            ? theme.colorScheme.primary.withValues(alpha: 0.5)
                            : theme.colorScheme.outline,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isDanger
                        ? theme.colorScheme.errorContainer
                        : (isDark
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.6)
                            : theme.colorScheme.primaryContainer.withValues(alpha: 0.7)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    days == 0 ? l10n.today : '$days ${l10n.days}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: isDanger
                          ? theme.colorScheme.onErrorContainer
                          : (isDark
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onPrimaryContainer),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}

class _UpcomingRoutineInfo {
  final Routine routine;
  final String slotLabel;

  _UpcomingRoutineInfo({
    required this.routine,
    required this.slotLabel,
  });
}

