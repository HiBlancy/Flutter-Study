import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/main_toolbar.dart';
import '../services/beauty_api_service.dart';
import '../models/beauty_product.dart';
import 'product_screen.dart';
import '../l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<BeautyProduct> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }



  void _onSearchChanged() {

    _debounceTimer?.cancel();

    final query = _searchController.text.trim();


    if (query.isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
        _errorMessage = null;
      });
      return;
    }


    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      if (query.length >= 2) {
        _performSearch(query);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await BeautyApiService.searchProducts(query);
      setState(() {
        _results = results;
        _hasSearched = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.searchConnectionError;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _debounceTimer?.cancel();
    setState(() {
      _results = [];
      _hasSearched = false;
      _errorMessage = null;
    });
    _searchFocusNode.requestFocus();
  }

  void _navigateToProduct(BeautyProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProductScreen(product: product, isFromSearch: true),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomAppBar(
      title: AppLocalizations.of(context)!.searchProducts,
      showDrawer: true,
      showBackButton: true,
      child: Column(
        children: [

          _buildSearchBar(theme, isDark),


          Expanded(child: _buildBody(theme)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme, bool isDark) {
    final subtleIcon = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final searchBgColor = isDark
        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
        : theme.colorScheme.primary.withValues(alpha: 0.08);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodyMedium?.copyWith(
          letterSpacing: 0.3,
        ),
        cursorColor: theme.colorScheme.primary,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchNameBrand,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),


          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              Icons.search_outlined,
              color: _searchFocusNode.hasFocus
                  ? theme.colorScheme.primary
                  : subtleIcon,
              size: 24,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),


          suffixIcon: _searchController.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: subtleIcon,
                            size: 20,
                          ),
                          onPressed: _clearSearch,
                          splashRadius: 24,
                        ),
                )
              : null,


          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.15)
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),


          filled: true,
          fillColor: searchBgColor,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    if (_isLoading && _results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.searchLoading,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: subtleText,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.error.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.wifi_off_outlined,
                size: 48,
                color: theme.colorScheme.error.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.searchErrorTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: subtleText),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _performSearch(_searchController.text),
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasSearched && _results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.search_off_outlined,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.searchNoResults,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                AppLocalizations.of(context)!.searchTryAnotherTerm,
                textAlign: TextAlign.center,
                style: TextStyle(color: subtleText),
              ),
            ),
          ],
        ),
      );
    }

    if (!_hasSearched) {
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
                Icons.spa_outlined,
                size: 56,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.searchBeautyProducts,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                AppLocalizations.of(context)!.searchExamplesExtended,
                textAlign: TextAlign.center,
                style: TextStyle(color: subtleText),
              ),
            ),
          ],
        ),
      );
    }


    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final product = _results[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _ProductTile(
            product: product,
            onTap: () => _navigateToProduct(product),
          ),
        );
      },
    );
  }
}

class _ProductTile extends StatefulWidget {
  final BeautyProduct product;
  final VoidCallback onTap;

  const _ProductTile({required this.product, required this.onTap});

  @override
  State<_ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<_ProductTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? theme.colorScheme.outline.withValues(alpha: 0.15)
                : theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(
                alpha: isDark ? 0.1 : 0.05,
              ),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [

                  _buildProductImage(theme),
                  const SizedBox(width: 12),


                  Expanded(
                    child: _buildProductInfo(theme),
                  ),


                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final subtleBg = isDark
        ? theme.colorScheme.primary.withValues(alpha: 0.1)
        : theme.colorScheme.primary.withValues(alpha: 0.08);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: subtleBg,
        border: Border.all(
          color: isDark
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : theme.colorScheme.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: widget.product.imageUrl != null &&
              widget.product.imageUrl!.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholderIcon(theme),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : _buildPlaceholderIcon(theme),
    );
  }

  Widget _buildPlaceholderIcon(ThemeData theme) {
    return Icon(
      Icons.spa_outlined,
      color: theme.colorScheme.primary.withValues(alpha: 0.5),
      size: 28,
    );
  }

  Widget _buildProductInfo(ThemeData theme) {
    final subtitleColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          widget.product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),


        if (widget.product.brand != null &&
            widget.product.brand!.isNotEmpty)
          Text(
            widget.product.brand!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          )
        else
          Text(
            AppLocalizations.of(context)!.noBrand,
            style: theme.textTheme.bodySmall?.copyWith(
              color: subtitleColor.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }
}