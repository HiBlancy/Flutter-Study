import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
import '../services/beauty_api_service.dart';
import '../models/beauty_product.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<BeautyProduct> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  Future<void> _onSearch(String query) async {
    if (query.trim().length < 2) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await BeautyApiService.searchProducts(query.trim());
      setState(() {
        _results = results;
        _hasSearched = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al buscar. Revisa tu conexión.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _results = [];
      _hasSearched = false;
      _errorMessage = null;
    });
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchBgColor = theme.colorScheme.onSurface.withValues(alpha: 0.05);
    final subtleIcon = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return CustomAppBar(
      title: 'Buscar productos',
      showDrawer: true,
      showBackButton: false,
      child: Column(
        children: [
          // Barra de búsqueda adaptativa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearch,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o marca...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                prefixIcon: Icon(Icons.search, color: subtleIcon),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: subtleIcon),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: searchBgColor, // Fondo dinámico
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 20,
                ),
              ),
              onChanged: (v) => setState(() {}),
            ),
          ),

          // Contenido principal
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final subtleIcon = theme.colorScheme.onSurface.withValues(alpha: 0.4);

    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 48, color: subtleIcon),
            const SizedBox(height: 12),
            Text(_errorMessage!, style: TextStyle(color: subtleText)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _onSearch(_searchController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Reintentar'),
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
            Icon(Icons.search_off, size: 48, color: subtleIcon),
            const SizedBox(height: 12),
            Text(
              'No se encontraron productos',
              style: TextStyle(color: subtleText),
            ),
            const SizedBox(height: 8),
            Text(
              'Prueba con otro término de búsqueda',
              style: TextStyle(fontSize: 12, color: subtleText),
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
            Icon(Icons.spa_outlined, size: 64, color: subtleIcon),
            const SizedBox(height: 16),
            Text(
              'Busca productos de belleza',
              style: TextStyle(fontSize: 16, color: subtleText),
            ),
            const SizedBox(height: 8),
            Text(
              'Ej: "L\'Oréal", "hidratante", "champú"',
              style: TextStyle(fontSize: 13, color: subtleText),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _results.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: theme.colorScheme.onSurface.withValues(
          alpha: 0.1,
        ), // Divisor adaptativo
      ),
      itemBuilder: (context, index) => _ProductTile(
        product: _results[index],
        onTap: () => _navigateToProduct(_results[index]),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final BeautyProduct product;
  final VoidCallback onTap;

  const _ProductTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleIcon = theme.colorScheme.onSurface.withValues(alpha: 0.4);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: product.imageUrl != null && product.imageUrl!.isNotEmpty
            ? Image.network(
                product.imageUrl!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _PlaceholderImage(),
              )
            : _PlaceholderImage(),
      ),
      title: Text(
        product.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: product.brand != null && product.brand!.isNotEmpty
          ? Text(
              product.brand!,
              style: TextStyle(
                fontSize: 12,
                color: theme
                    .colorScheme
                    .primary, // Resalta la marca con tu color ciruela/rosa
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right,
        color: subtleIcon,
      ), // Adiós Colors.grey
      onTap: onTap,
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(
          alpha: 0.05,
        ), // Fondo dinámico
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.spa_outlined,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
      ),
    );
  }
}
