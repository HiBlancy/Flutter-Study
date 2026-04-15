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
  List<BeautyProduct> _products = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final name = await _authService.getUserName();
    final response = await _productService.getProducts(page: 1, limit: 10);

    if (mounted) {
      setState(() {
        _userName = name ?? 'Usuario';
        _products = response?.products ?? [];
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
                                // Texto principal "Your skin's"
                                Text( //!!!!!!!!!!!!!!!!!!!!
                                  _getMainGreetingLine1(),
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 28,
                                    color: theme.colorScheme.onSurface,
                                    fontFamily: 'crimsonText',
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
                                  .eco_outlined, // Puedes cambiarlo por Icons.eco, Icons.blur_on, etc.
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
      return 'BUENOS DÍAS, $name';
    } else if (hour < 18) {
      return 'BUENAS TARDES, $name';
    } else {
      return 'BUENAS NOCHES, $name';
    }
  }

  String _getMainGreetingLine1() {
    return "texto";
  }

  Widget _buildQuickActions(
    ThemeData theme,
    AppLocalizations l10n,
    bool isDark,
  ) {
    // En modo oscuro: usamos colores más saturados y con variación
    // En modo claro: los tonos más suaves que ya tienes

    final color1 = isDark
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.6)
        : theme.colorScheme.primaryContainer.withValues(alpha: 0.4);

    final color2 = isDark
        ? Color(0xffe8d5f2).withValues(alpha: 0.5) // Púrpura suave
        : theme.colorScheme.primaryContainer.withValues(alpha: 0.2);

    final color3 = isDark
        ? Color(0xffd9a3c8).withValues(alpha: 0.4) // Rosa más saturada
        : theme.colorScheme.primaryContainer.withValues(alpha: 0.2);

    final color4 = isDark
        ? Color(0xffb095a8).withValues(alpha: 0.3) // Rosa neutral suave
        : theme.colorScheme.primaryContainer.withValues(alpha: 0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
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
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  Icons.face_retouching_natural_outlined,
                  l10n.routines,
                  'Próximamente',
                  color2,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
                  theme,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  Icons.category_outlined,
                  l10n.categories,
                  'Próximamente',
                  color3,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
                  theme,
                  isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  Icons.history,
                  'Usados',
                  'Próximamente',
                  color4,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
                  theme,
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringSoonProducts(bool isDark) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final now = DateTime.now();
    final expiringSoon = _products.where((product) {
      if (product.expirationDate == null) return false;
      final days = product.expirationDate!.difference(now).inDays;
      return days >= 0 && days <= 30;
    }).toList();

    // Limitar a 6 productos
    final displayProducts = expiringSoon.take(6).toList();

    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Solo el título (sin el botón)
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
                    'Prioriza estos productos antes de que caduquen',
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
        if (expiringSoon.isEmpty)
          _buildEmptyCard(theme, l10n, isDark)
        else
          // GridView vertical en lugar de ListView
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columnas
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75, // Proporción vertical más alta
              ),
              itemCount: displayProducts.length,
              itemBuilder: (context, index) =>
                  _buildExpiringProductCardVertical(
                    displayProducts[index],
                    isDark,
                  ),
            ),
          ),
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

  return Card(
    elevation: 0,
    color: isDark
        ? theme.colorScheme.surfaceContainerHigh
        : theme.colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: isDark
            ? theme.colorScheme.primary.withValues(alpha: 0.2)
            : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
    ),
    child: InkWell(
      onTap: () => _navigateToProduct(product),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 140, // Aumentado de 100 a 160 para hacerla más vertical
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
                        size: 50, // Icono un poco más grande
                        color: isDark
                            ? theme.colorScheme.primary.withValues(alpha: 0.5)
                            : theme.colorScheme.outline,
                      ),
              ),
            ),
          ),
          // Contenido
          Padding(
            padding: const EdgeInsets.all(12), // Padding restaurado a 12
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 12), // Fuente ligeramente más grande
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Fuente ligeramente más grande
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Días restantes
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDanger
                        ? theme.colorScheme.errorContainer
                        : (isDark
                            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
                            : theme.colorScheme.primaryContainer.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$days ${l10n.days}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
