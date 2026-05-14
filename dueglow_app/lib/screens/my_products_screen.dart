
import 'package:flutter/material.dart';
import '../models/beauty_product.dart';
import '../models/product_list_type.dart';
import '../services/product_service.dart';
import '../widgets/main_toolbar.dart';
import '../widgets/product_card.dart';
import 'product_screen.dart';
import '../l10n/app_localizations.dart';

enum HaveProductsFilter { all, opened, expired }
enum ProductSortOption {
  addedNewest,
  alphabetical,
  expirationSoonest,
}

class MyProductsScreen extends StatefulWidget {
  final ProductListType? initialListType;
  final HaveProductsFilter? initialHaveFilter;
  /// True when this screen is pushed on top of another (e.g. from Home), so the
  /// app bar shows a back control. False when used as a bottom-tab root.
  final bool showBackButton;

  const MyProductsScreen({
    super.key,
    this.initialListType,
    this.initialHaveFilter,
    this.showBackButton = false,
  });

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();

  ProductListType? _selectedListType;
  HaveProductsFilter _haveProductsFilter = HaveProductsFilter.all;
  ProductSortOption _sortOption = ProductSortOption.addedNewest;
  List<BeautyProduct> _allProducts = [];
  List<BeautyProduct> _filteredProducts = [];
  Set<String> _expiredProductIds = {};
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isMoreLoading = false;
  bool _hasMore = true;
  bool _hasLoadedCompleteDataset = false;
  bool _isHydratingSearchDataset = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedListType = widget.initialListType;
    _haveProductsFilter = widget.initialHaveFilter ?? HaveProductsFilter.all;
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
        _hasLoadedCompleteDataset = false;
      });
    } else {
      setState(() => _isMoreLoading = true);
    }

    try {
      if (reset) {
        final expiredProducts = await _productService.getExpiredProducts();
        _expiredProductIds = expiredProducts
            .map((p) => p.id)
            .whereType<String>()
            .toSet();
      }

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
          _applyCurrentFilters();
          _currentPage++;


          if (response.currentPage >= response.totalPages) {
            _hasMore = false;
            _hasLoadedCompleteDataset = true;
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

  bool _isProductExpired(BeautyProduct product) {
    final id = product.id;
    if (id != null && _expiredProductIds.contains(id)) {
      return true;
    }

    final expirationDate = product.expirationDate;
    if (expirationDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final productDate = DateTime(
      expirationDate.year,
      expirationDate.month,
      expirationDate.day,
    );
    return productDate.isBefore(today);
  }

  bool _isOpenedProduct(BeautyProduct product) {
    return product.isOpened == true && product.openedDate != null;
  }

  void _applyCurrentFilters() {
    var result = List<BeautyProduct>.from(_allProducts);

    if (_selectedListType == ProductListType.have) {
      switch (_haveProductsFilter) {
        case HaveProductsFilter.all:
          break;
        case HaveProductsFilter.opened:
          result = result.where(_isOpenedProduct).toList();
          break;
        case HaveProductsFilter.expired:
          result = result.where(_isProductExpired).toList();
          break;
      }
    }

    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isNotEmpty) {
      result = result.where((product) {
        final name = product.name.toLowerCase();
        final brand = (product.brand ?? '').toLowerCase();
        return name.contains(normalizedQuery) || brand.contains(normalizedQuery);
      }).toList();
    }

    result.sort((a, b) {
      switch (_sortOption) {
        case ProductSortOption.addedNewest:
          final dateA = a.addedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final dateB = b.addedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return dateB.compareTo(dateA);
        case ProductSortOption.alphabetical:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case ProductSortOption.expirationSoonest:
          final dateA =
              a.expirationDate ?? DateTime.fromMillisecondsSinceEpoch(253402300799000);
          final dateB =
              b.expirationDate ?? DateTime.fromMillisecondsSinceEpoch(253402300799000);
          return dateA.compareTo(dateB);
      }
    });

    _filteredProducts = result;
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
    final isAdvancedHaveFilter =
        _selectedListType == ProductListType.have &&
        _haveProductsFilter != HaveProductsFilter.all;

    if (isAdvancedHaveFilter) {
      await _loadAllHaveProductsForAdvancedFilter();
      return;
    }

    await _loadProducts(reset: true);
  }

  void _changeListType(ProductListType? newType) {
    setState(() {
      _selectedListType = (_selectedListType == newType) ? null : newType;
      _haveProductsFilter = HaveProductsFilter.all;
      _searchQuery = '';
      _searchController.clear();
      _sortOption = ProductSortOption.addedNewest;
      _hasLoadedCompleteDataset = false;
    });
    _loadProducts(reset: true);
  }

  void _changeHaveProductsFilter(HaveProductsFilter filter) {
    if (_selectedListType != ProductListType.have) return;

    setState(() => _haveProductsFilter = filter);

    if (filter == HaveProductsFilter.all) {
      _loadProducts(reset: true);
      return;
    }

    _loadAllHaveProductsForAdvancedFilter();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _applyCurrentFilters();
    });

    final normalizedQuery = value.trim().toLowerCase();
    if (normalizedQuery.isNotEmpty &&
        !_hasLoadedCompleteDataset &&
        !_isHydratingSearchDataset) {
      _hydrateAllProductsForSearch();
    }
  }

  String _sortOptionLabel(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.addedNewest:
        return 'Recientes';
      case ProductSortOption.alphabetical:
        return 'A-Z';
      case ProductSortOption.expirationSoonest:
        return 'Caducidad';
    }
  }

  IconData _sortOptionIcon(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.addedNewest:
        return Icons.schedule;
      case ProductSortOption.alphabetical:
        return Icons.sort_by_alpha;
      case ProductSortOption.expirationSoonest:
        return Icons.event_busy;
    }
  }

  Future<void> _loadAllHaveProductsForAdvancedFilter() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final expiredProducts = await _productService.getExpiredProducts();
      _expiredProductIds = expiredProducts
          .map((p) => p.id)
          .whereType<String>()
          .toSet();

      final allHaveProducts = <BeautyProduct>[];
      var page = 1;
      const limit = 100;
      var totalPages = 1;

      do {
        final response = await _productService.getProducts(
          page: page,
          limit: limit,
          listType: ProductListType.have.value,
        );

        if (response == null) break;

        allHaveProducts.addAll(response.products);
        totalPages = response.totalPages;
        page++;
      } while (page <= totalPages);

      if (!mounted) return;
      setState(() {
        _allProducts = allHaveProducts;
        _hasMore = false;
        _hasLoadedCompleteDataset = true;
        _isMoreLoading = false;
        _isLoading = false;
        _currentPage = page;
        _applyCurrentFilters();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
        _isMoreLoading = false;
      });
    }
  }

  Future<void> _hydrateAllProductsForSearch() async {
    _isHydratingSearchDataset = true;
    if (mounted) {
      setState(() => _isMoreLoading = true);
    }

    try {
      final allProducts = <BeautyProduct>[];
      var page = 1;
      var totalPages = 1;

      do {
        final response = await _productService.getProducts(
          page: page,
          limit: 100,
          listType: _selectedListType?.value,
        );

        if (response == null) break;

        allProducts.addAll(response.products);
        totalPages = response.totalPages;
        page++;
      } while (page <= totalPages);

      if (!mounted) return;

      setState(() {
        _allProducts = allProducts;
        _currentPage = page;
        _hasMore = false;
        _hasLoadedCompleteDataset = true;
        _isMoreLoading = false;
        _applyCurrentFilters();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isMoreLoading = false);
    } finally {
      _isHydratingSearchDataset = false;
    }
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
    return _byListType<String>(
      allValue: l10n.allProducts,
      haveValue: 'Tengo',
      wishlistValue: 'Deseados',
      usedValue: 'Terminados',
    );
  }

  String _getEmptyMessage() {
    final l10n = AppLocalizations.of(context)!;
    return _byListType<String>(
      allValue: l10n.noProductsRegistered,
      haveValue: l10n.noProductsInHave,
      wishlistValue: l10n.noProductsInWishlist,
      usedValue: l10n.noFinishedProducts,
    );
  }

  String _getEmptySubMessage() {
    final l10n = AppLocalizations.of(context)!;
    return _byListType<String>(
      allValue: l10n.addFirstProductsHint,
      haveValue: l10n.haveProductsHint,
      wishlistValue: l10n.wishlistProductsHint,
      usedValue: l10n.usedProductsHint,
    );
  }

  T _byListType<T>({
    required T allValue,
    required T haveValue,
    required T wishlistValue,
    required T usedValue,
  }) {
    final selected = _selectedListType;
    if (selected == null) {
      return allValue;
    }

    switch (selected) {
      case ProductListType.have:
        return haveValue;
      case ProductListType.wishlist:
        return wishlistValue;
      case ProductListType.used:
        return usedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomAppBar(
      title: AppLocalizations.of(context)!.myProducts,
      showDrawer: true,
      showBackButton: widget.showBackButton,
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

          if (_selectedListType == ProductListType.have)
            _buildHaveFilters(theme),

          _buildSearchAndSortControls(theme),


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

  Widget _buildHaveFilters(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    Widget chip({
      required String label,
      required IconData icon,
      required bool selected,
      required VoidCallback onTap,
    }) {
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FilterChip(
          selected: selected,
          onSelected: (_) => onTap(),
          label: Text(label),
          avatar: Icon(
            icon,
            size: 16,
            color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
          ),
          backgroundColor: isDark
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
          selectedColor: theme.colorScheme.primary,
          labelStyle: TextStyle(
            color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            chip(
              label: l10n.filterAll,
              icon: Icons.list_alt,
              selected: _haveProductsFilter == HaveProductsFilter.all,
              onTap: () => _changeHaveProductsFilter(HaveProductsFilter.all),
            ),
            chip(
              label: l10n.filterOpened,
              icon: Icons.lock_open,
              selected: _haveProductsFilter == HaveProductsFilter.opened,
              onTap: () => _changeHaveProductsFilter(HaveProductsFilter.opened),
            ),
            chip(
              label: l10n.filterExpired,
              icon: Icons.warning_amber_rounded,
              selected: _haveProductsFilter == HaveProductsFilter.expired,
              onTap: () => _changeHaveProductsFilter(HaveProductsFilter.expired),
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
                  isExpired: _isProductExpired(product),
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

  Widget _buildSearchAndSortControls(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchNameBrand,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: const Icon(Icons.close),
                      ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                filled: true,
                fillColor: isDark
                    ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
                    : theme.colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.25),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.25),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<ProductSortOption>(
            tooltip: 'Ordenar',
            onSelected: (option) {
              setState(() {
                _sortOption = option;
                _applyCurrentFilters();
              });
            },
            itemBuilder: (context) => ProductSortOption.values
                .map(
                  (option) => PopupMenuItem<ProductSortOption>(
                    value: option,
                    child: Row(
                      children: [
                        Icon(
                          _sortOptionIcon(option),
                          size: 18,
                          color: option == _sortOption
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(alpha: 0.75),
                        ),
                        const SizedBox(width: 10),
                        Text(_sortOptionLabel(option)),
                      ],
                    ),
                  ),
                )
                .toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(_sortOptionIcon(_sortOption), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    _sortOptionLabel(_sortOption),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

