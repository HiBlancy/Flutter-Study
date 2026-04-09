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
    final products = await _productService.getProducts();

    if (mounted) {
      setState(() {
        _userName = name ?? 'Usuario';
        _products = products;
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
    final l10n = AppLocalizations.of(context)!;

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
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            l10n.helloUser(_userName),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildExpiringSoonProducts(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final l10n = AppLocalizations.of(context)!;

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
                  () {
                    Navigator.pushNamed(context, AppConstants.routeMyProducts);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  Icons.face_retouching_natural_outlined,
                  l10n.routines,
                  'Próximamente',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
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
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  Icons.history,
                  'Usados',
                  'Próximamente',
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Próximamente')),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpiringSoonProducts() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    final now = DateTime.now();
    final expiringSoon = _products.where((product) {
      if (product.expirationDate == null) return false;
      final daysUntilExpiration = product.expirationDate!.difference(now).inDays;
      return daysUntilExpiration >= 0 && daysUntilExpiration <= 30;
    }).toList();

    final l10n = AppLocalizations.of(context)!;

    if (expiringSoon.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Card(
          elevation: isDarkMode ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isDarkMode ? BorderSide(color: borderColor) : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Usamos el primary color en lugar del verde fijo para mantener la marca
                Icon(Icons.check_circle_outline, size: 48, color: theme.colorScheme.primary),
                const SizedBox(height: 12),
                Text(
                  l10n.allFine,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.noProdExpiring,
                  style: TextStyle(fontSize: 14, color: subtleText),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.expiringSoon,
                style: theme.textTheme.headlineSmall,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppConstants.routeMyProducts);
                },
                child: Text(
                  l10n.seeAll,
                  style: TextStyle(
                    color: theme.colorScheme.primary, // Cambiado de tertiary a primary para asegurar consistencia
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: expiringSoon.length > 5 ? 5 : expiringSoon.length,
          itemBuilder: (context, index) {
            final product = expiringSoon[index];
            return _buildExpiringProductCard(product);
          },
        ),
      ],
    );
  }

  Widget _buildExpiringProductCard(BeautyProduct product) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final subtleBg = theme.colorScheme.onSurface.withValues(alpha: 0.05);
    final subtleIcon = theme.colorScheme.onSurface.withValues(alpha: 0.4);
    final subtitleColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    final daysUntilExpiration = product.expirationDate!.difference(DateTime.now()).inDays;
    final isDanger = daysUntilExpiration <= 7;

    // Colores dinámicos para la etiqueta de caducidad
    final badgeBgColor = isDanger
        ? theme.colorScheme.error.withValues(alpha: 0.15)
        : Colors.orange.withValues(alpha: 0.15);
        
    final badgeTextColor = isDanger
        ? (isDarkMode ? Colors.red[300] : theme.colorScheme.error)
        : (isDarkMode ? Colors.orange[300] : Colors.orange[800]);

    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isDarkMode ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDarkMode ? BorderSide(color: borderColor) : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _navigateToProduct(product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Imagen del producto
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: subtleBg,
                ),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.face_rounded, color: subtleIcon, size: 30);
                          },
                        ),
                      )
                    : Icon(Icons.face_rounded, color: subtleIcon, size: 30),
              ),
              const SizedBox(width: 12),

              // Información del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (product.brand != null && product.brand!.isNotEmpty)
                      Text(
                        product.brand!,
                        style: theme.textTheme.bodySmall?.copyWith(color: subtitleColor),
                      ),
                  ],
                ),
              ),

              // Indicador de días restantes
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '$daysUntilExpiration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: badgeTextColor,
                      ),
                    ),
                    Text(
                      l10n.days,
                      style: TextStyle(
                        fontSize: 10,
                        color: badgeTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: subtleIcon),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final borderColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    return Card(
      elevation: isDarkMode ? 0 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDarkMode ? BorderSide(color: borderColor) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                title, 
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5)
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