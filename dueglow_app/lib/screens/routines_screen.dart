
import 'package:flutter/material.dart';
import '../models/routine_model.dart';
import '../services/routine_service.dart';
import '../widgets/main_toolbar.dart';
import '../widgets/custom_button.dart';
import 'add_routine_screen.dart';
import 'routine_detail.screen.dart';
import '../l10n/app_localizations.dart';
import '../widgets/tutorial_target.dart';
import '../services/notifications_coordinator.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen>
    with SingleTickerProviderStateMixin {
  final RoutineService _routineService = RoutineService();
  late TabController _tabController;

  List<Routine> _routines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRoutines();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRoutines() async {
    setState(() => _isLoading = true);
    try {
      final routines = await _routineService.getRoutines();
      if (mounted) setState(() => _routines = routines);
    } catch (e) {
      if (mounted) _showSnackBar(AppLocalizations.of(context)!.routinesLoadError, isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteRoutine(Routine routine) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteRoutineTitle),
        content: Text(AppLocalizations.of(context)!.deleteRoutineQuestion(routine.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed != true || routine.id == null) return;

    try {
      await _routineService.deleteRoutine(routine.id!);
      _showSnackBar(AppLocalizations.of(context)!.routineDeleted);
      NotificationsCoordinator.refresh();
      await _loadRoutines();
    } catch (e) {
      _showSnackBar(AppLocalizations.of(context)!.routineDeleteError, isError: true);
    }
  }

  void _navigateToAdd() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddRoutineScreen()),
    );
    if (created == true) await _loadRoutines();
  }

  void _navigateToDetail(Routine routine) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => RoutineDetailScreen(routine: routine)),
    );
    if (changed == true) await _loadRoutines();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? theme.colorScheme.error : theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<Routine> get _morningRoutines =>
      _routines.where((r) => r.type == RoutineType.morning).toList();
  List<Routine> get _nightRoutines =>
      _routines.where((r) => r.type == RoutineType.night).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return CustomAppBar(
      title: l10n.routines,
      showDrawer: true,
      showBackButton: false,
      child: Stack(
        children: [
          Column(
            children: [

              TutorialTarget(
                id: 'routines_tabs',
                child: Container(
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                decoration: BoxDecoration(
                  color: isDark
                      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
                      : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: theme.colorScheme.onPrimary,
                  unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  padding: const EdgeInsets.all(4),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wb_sunny_outlined, size: 18),
                          SizedBox(width: 6),
                          Text(l10n.morning),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.nights_stay_outlined, size: 18),
                          SizedBox(width: 6),
                          Text(l10n.night),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ),
              const SizedBox(height: 8),


              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildRoutineList(_morningRoutines, RoutineType.morning, isDark),
                          _buildRoutineList(_nightRoutines, RoutineType.night, isDark),
                        ],
                      ),
              ),
            ],
          ),


          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _navigateToAdd,
              icon: const Icon(Icons.add),
              label: Text(l10n.newRoutine),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineList(List<Routine> routines, RoutineType type, bool isDark) {
    if (routines.isEmpty) {
      return _buildEmptyState(type, isDark);
    }

    return RefreshIndicator(
      onRefresh: _loadRoutines,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        itemCount: routines.length,
        itemBuilder: (_, i) => _buildRoutineCard(routines[i], isDark),
      ),
    );
  }

  Widget _buildEmptyState(RoutineType type, bool isDark) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isMorning = type == RoutineType.morning;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
                    : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isMorning ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
                size: 36,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isMorning ? l10n.noMorningRoutines : l10n.noNightRoutines,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.createFirstRoutineHint(isMorning ? l10n.morning.toLowerCase() : l10n.night.toLowerCase()),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 28),
            CustomButton(
              text: l10n.createRoutine,
              onPressed: _navigateToAdd,
              type: ButtonType.primary,
              size: ButtonSize.medium,
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard(Routine routine, bool isDark) {
    final theme = Theme.of(context);
    final isMorning = routine.type == RoutineType.morning;

    final dayLabels = {
      'monday': 'L',
      'tuesday': 'M',
      'wednesday': 'X',
      'thursday': 'J',
      'friday': 'V',
      'saturday': 'S',
      'sunday': 'D',
    };
    final allDays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _navigateToDetail(routine),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.12)
                  : theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isMorning ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
                        size: 22,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routine.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${routine.products.length} producto${routine.products.length != 1 ? 's' : ''}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error.withValues(alpha: 0.7),
                        size: 20,
                      ),
                      onPressed: () => _deleteRoutine(routine),
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: allDays.map((day) {
                    final isActive = routine.days.contains(day);
                    return Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        dayLabels[day]!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    );
                  }).toList(),
                ),


                if (routine.products.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: routine.products.length,
                      itemBuilder: (_, i) {
                        final p = routine.products[i];
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.face_retouching_natural,
                                size: 14,
                                color: theme.colorScheme.primary.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                p.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}