import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
import '../widgets/custom_button.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, List<Map<String, dynamic>>> _stashData = {
    'Facial': [
      {'name': 'Limpieza', 'icon': Icons.water_drop_outlined},
      {'name': 'Sérums', 'icon': Icons.science_outlined},
      {'name': 'Hidratación', 'icon': Icons.spa_outlined},
      {'name': 'Tratamientos', 'icon': Icons.auto_fix_high_outlined},
      {'name': 'Protección', 'icon': Icons.wb_sunny_outlined},
    ],
    'Corporal': [
      {'name': 'Gel exfoliante', 'icon': Icons.grain},
      {'name': 'Crema', 'icon': Icons.clean_hands_outlined},
      {'name': 'Manos', 'icon': Icons.front_hand_outlined},
      {'name': 'Desodorante', 'icon': Icons.air_outlined},
    ],
    'Capilar': [
      {'name': 'Champú', 'icon': Icons.wash_outlined},
      {'name': 'Mascarilla', 'icon': Icons.face_retouching_natural},
      {'name': 'Acondicionador', 'icon': Icons.water_outlined},
      {'name': 'Sérum capilar', 'icon': Icons.spa_outlined},
    ],
    'Maquillaje': [
      {'name': 'Rostro', 'icon': Icons.brush_outlined},
      {'name': 'Ojos', 'icon': Icons.remove_red_eye_outlined},
      {'name': 'Labios', 'icon': Icons.face_4_outlined},
      {'name': 'Cejas', 'icon': Icons.auto_awesome_outlined},
    ],
    'Otros': [
      {'name': 'Uñas', 'icon': Icons.back_hand_outlined},
      {'name': 'Fragancia', 'icon': Icons.local_florist_outlined},
      {'name': 'Higiene íntima', 'icon': Icons.sanitizer_outlined},
      {'name': 'Solares corporales', 'icon': Icons.sunny},
    ],
  };

  final Map<String, String> _selectedSubcategories = {};

  @override
  void initState() {
    super.initState();
    _stashData.forEach((key, value) {
      if (value.isNotEmpty) {
        _selectedSubcategories[key] = value.first['name'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final tabs = _stashData.keys.toList();

    return DefaultTabController(
      length: tabs.length,
      child: CustomAppBar(
        title: l10n.vanity,
        showDrawer: true,
        showBackButton: false,
        child: Column(
          children: [
            _buildTabBar(theme, tabs, isDark),

            Expanded(
              child: TabBarView(
                children: tabs
                    .map((tab) => _buildTabContent(tab, theme, isDark))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme, List<String> tabs, bool isDark) {
    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            indicatorColor: theme.colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.5,
            ),
            labelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tabs: tabs
                .map(
                  (tab) => Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(tab),
                    ),
                  ),
                )
                .toList(),
          ),
          Divider(
            height: 1,
            color: isDark
                ? theme.colorScheme.outline.withValues(alpha: 0.1)
                : theme.colorScheme.outline.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String categoryName, ThemeData theme, bool isDark) {
    final subcategories = _stashData[categoryName] ?? [];
    final selectedSub = _selectedSubcategories[categoryName];

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSubcategorySelector(
            categoryName,
            subcategories,
            selectedSub,
            theme,
            isDark,
          ),

          _buildEmptyState(selectedSub, subcategories, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildSubcategorySelector(
    String categoryName,
    List<Map<String, dynamic>> subcategories,
    String? selectedSub,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 520;

          final cards = subcategories.map((sub) {
            final isSelected = sub['name'] == selectedSub;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: GestureDetector(
                onTap: () {
                  setState(
                    () => _selectedSubcategories[categoryName] = sub['name'],
                  );
                },
                child: _buildSubcategoryCard(sub, isSelected, theme, isDark),
              ),
            );
          }).toList();

          if (isSmallScreen) {
            return SizedBox(
              height: 132,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisSize: MainAxisSize.min, children: cards),
              ),
            );
          }

          return Center(
            child: Wrap(alignment: WrapAlignment.center, children: cards),
          );
        },
      ),
    );
  }

  Widget _buildSubcategoryCard(
    Map<String, dynamic> sub,
    bool isSelected,
    ThemeData theme,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.2)
                : isDark
                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                : theme.colorScheme.primary.withValues(alpha: 0.05),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.2)
                  : theme.colorScheme.outline.withValues(alpha: 0.15),
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            sub['icon'] as IconData,
            size: 28,
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: 92,
          child: Text(
            sub['name'] as String,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    String? selectedSub,
    List<Map<String, dynamic>> subcategories,
    ThemeData theme,
    bool isDark,
  ) {
    if (selectedSub == null || subcategories.isEmpty) {
      return const SizedBox.shrink();
    }

    final selectedItem = subcategories.firstWhere(
      (s) => s['name'] == selectedSub,
      orElse: () => subcategories.first,
    );

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark
            ? theme.colorScheme.primary.withValues(alpha: 0.08)
            : theme.colorScheme.primary.withValues(alpha: 0.06),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.primary.withValues(alpha: 0.12),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
            ),
            child: Icon(
              selectedItem['icon'] as IconData,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 28),

          Text(
            AppLocalizations.of(context)!.yourProductsOf(selectedSub),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            AppLocalizations.of(context)!.noCategorizedProductsSection,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: AppLocalizations.of(context)!.addProduct,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.info, color: theme.colorScheme.onPrimary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.featureInDevelopment,
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              type: ButtonType.primary,
              size: ButtonSize.full,
              icon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
