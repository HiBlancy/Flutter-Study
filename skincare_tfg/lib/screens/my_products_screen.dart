
import 'package:flutter/material.dart';
import '../models/beauty_product.dart';
import '../models/product_list_type.dart';
import '../services/product_service.dart';
import '../widgets/main_toolbar.dart';
import '../widgets/product_card.dart';
import 'product_screen.dart';
import '../l10n/app_localizations.dart';

class MyProductsScreen extends StatefulWidget {
  final ProductListType? initialListType;

  const MyProductsScreen({super.key, this.initialListType});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final ProductService _productService = ProductService();

  ProductListType? _selectedListType;
  List<BeautyProduct> _allProducts = [];
  List<BeautyProduct> _filteredProducts = [];
  bool _isLoading = true;
  String? _error;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isMoreLoading = false;
  bool _hasMore = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedListType = widget.initialListType;
    _refreshProducts();


    _scrollController.addListener(() {

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!_isMoreLoading && _hasMore && !_isLoading) {
          _loadProducts(reset: false);
        }
      }
    });
  }

  Future<void> _loadProducts({bool reset = false}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _currentPage = 1;
        _allProducts = [];
        _hasMore = true;
      });
    } else {
      setState(() => _isMoreLoading = true);
    }

    try {

      final response = await _productService.getProducts(
        page: _currentPage,
        limit: 12,
        listType: _selectedListType?.value,
      );

      if (mounted && response != null) {
        setState(() {
          _allProducts.addAll(
            response.products,
          );
          _filteredProducts = _allProducts;
          _currentPage++;


          if (response.currentPage >= response.totalPages) {
            _hasMore = false;
          }

          _isLoading = false;
          _isMoreLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
        _isMoreLoading = false;
      });
    }
  }

  Widget _buildInfoMessage(ThemeData theme) {
    if (_selectedListType != ProductListType.used) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.usedProductsInfo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshProducts() async {
    await _loadProducts(reset: true);
  }

  void _changeListType(ProductListType? newType) {
    setState(() {
      _selectedListType = (_selectedListType == newType) ? null : newType;
    });
    _loadProducts(reset: true);
  }

  Future<void> _navigateToProduct(BeautyProduct product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductScreen(product: product, isFromSearch: false),
      ),
    );
    await _refreshProducts();
  }

  String _getTitle() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedListType == null) {
      return l10n.allProducts;
    }
    switch (_selectedListType!) {
      case ProductListType.have:
        return 'Tengo';
      case ProductListType.wishlist:
        return 'Deseados';
      case ProductListType.used:
        return 'Terminados';
    }
  }

  String _getEmptyMessage() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedListType == null) {
      return l10n.noProductsRegistered;
    }
    switch (_selectedListType!) {
      case ProductListType.have:
        return l10n.noProductsInHave;
      case ProductListType.wishlist:
        return l10n.noProductsInWishlist;
      case ProductListType.used:
        return l10n.noFinishedProducts;
    }
  }

  String _getEmptySubMessage() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedListType == null) {
      return l10n.addFirstProductsHint;
    }
    switch (_selectedListType!) {
      case ProductListType.have:
        return l10n.haveProductsHint;
      case ProductListType.wishlist:
        return l10n.wishlistProductsHint;
      case ProductListType.used:
        return l10n.usedProductsHint;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomAppBar(
      title: AppLocalizations.of(context)!.myProducts,
      showDrawer: true,
      child: Column(
        children: [

          _buildFilterChips(theme),


          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTitle(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.productsCount(
                        _filteredProducts.length,
                        _filteredProducts.length == 1 ? '' : 's',
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_selectedListType != null)
                  TextButton.icon(
                    onPressed: () => _changeListType(_selectedListType),
                    icon: const Icon(Icons.close, size: 18),
                    label: Text(AppLocalizations.of(context)!.clear),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),


          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              color: theme.colorScheme.primary,
              child: _buildContent(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? theme.colorScheme.outline.withValues(alpha: 0.1)
                : theme.colorScheme.outline.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ProductListType.values.map((type) {
            final isSelected = _selectedListType == type;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildFilterChip(type, isSelected, theme),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    ProductListType type,
    bool isSelected,
    ThemeData theme,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? type.color
            : (isDark
                  ? theme.colorScheme.surface.withValues(alpha: 0.8)
                  : theme.colorScheme.primary.withValues(alpha: 0.08)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? type.color
              : (isDark
                    ? type.color.withValues(alpha: 0.3)
                    : type.color.withValues(alpha: 0.2)),
          width: isSelected ? 2 : 1.5,
        ),
      ),
      child: GestureDetector(
        onTap: () => _changeListType(type),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type.icon,
              color: isSelected ? Colors.white : type.color,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              type.label,
              style: TextStyle(
                color: isSelected ? Colors.white : type.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
          strokeWidth: 3,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                _selectedListType?.icon ?? Icons.inbox_outlined,
                size: 56,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _getEmptyMessage(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _getEmptySubMessage(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildInfoMessage(theme),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: _filteredProducts.length + (_isMoreLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _filteredProducts.length) {
                final product = _filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () => _navigateToProduct(product),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

