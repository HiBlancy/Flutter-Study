import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/beauty_product.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../widgets/main_toolbar.dart';
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

  String _userName = '';
  bool _isLoading = true;
  List<BeautyProduct> _expiringSoonProducts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final name = await _authService.getUserName();
    final expiringProducts = await _productService.getExpiringSoon(days: 30);

    if (mounted) {
      setState(() {
        _userName = name ?? AppLocalizations.of(context)!.defaultUserName;
        _expiringSoonProducts = expiringProducts;
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
                    _buildQuickActions(theme, l10n, isDark),
                    const SizedBox(height: 32),
                    _buildExpiringSoonProducts(isDark),
                  ],
                ),
              ),
      ),
    );
  }

  String _getGreetingPrefix() {
    final hour = DateTime.now().hour;
    final name = _userName;

    if (hour < 12) {
      return AppLocalizations.of(context)!.morningGreeting(name).toUpperCase();
    } else if (hour < 18) {
      return AppLocalizations.of(context)!.afternoonGreeting(name).toUpperCase();
    } else {
      return AppLocalizations.of(context)!.eveningGreeting(name).toUpperCase();
    }
  }

  Widget _buildQuickActions(
    ThemeData theme,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final color1 = isDark
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.6)
        : theme.colorScheme.primaryContainer.withValues(alpha: 0.4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildActionCard(
                  Icons.shopping_bag_outlined,
                  l10n.myProducts,
                  l10n.seeAll,
                  color1,
                  () => Navigator.pushNamed(
                    context,
                    AppConstants.routeMyProducts,
                  ),
                  theme,
                  isDark,
                ),
    );
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
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppConstants.routeMyProducts,
                  ),
                  child: Text(
                    l10n.seeAll,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
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
                    '$days ${l10n.days}',
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

  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle,
    Color bgColor,
    VoidCallback onTap,
    ThemeData theme,
    bool isDark,
  ) {
    return Card(
      elevation: 0,
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: isDark
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.8,
                        )
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

