// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
import '../services/beauty_api_service.dart';
import '../services/product_service.dart';
import '../models/beauty_product.dart';
import 'product_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();

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

  Future<void> _addProductToList(BeautyProduct product) async {
    // Mostrar diálogo de confirmación
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar a mis productos'),
        content: Text('¿Quieres agregar "${product.name}" a tu lista de productos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final added = await _productService.addProductToHave(product);
      
      // Cerrar loading
      Navigator.pop(context);

      if (added != null) {
        // Mostrar éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ ${product.name} agregado a tus productos'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Opcional: navegar al detalle del producto agregado
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(product: added),
          ),
        );
      } else {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al agregar el producto. Intenta de nuevo.'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Buscar productos',
      showDrawer: true,
      showBackButton: false,
      child: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o marca...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
              onChanged: (v) => setState(() {}),
            ),
          ),

          // Contenido principal
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _onSearch(_searchController.text),
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
            Icon(Icons.search_off, size: 48, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text('No se encontraron productos', 
              style: TextStyle(color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 8),
            Text('Prueba con otro término de búsqueda',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Busca productos de belleza',
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.outline),
            ),
            const SizedBox(height: 8),
            Text(
              'Ej: "L\'Oréal", "hidratante", "champú"',
              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) => _ProductTile(
        product: _results[index],
        onAddPressed: () => _addProductToList(_results[index]),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final BeautyProduct product;
  final VoidCallback onAddPressed;

  const _ProductTile({
    required this.product,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: product.imageUrl != null
            ? Image.network(
                product.imageUrl!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _PlaceholderImage(),
              )
            : _PlaceholderImage(),
      ),
      title: Text(
        product.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: product.brand.isNotEmpty
          ? Text(
              product.brand,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outline, color: Colors.green),
        onPressed: onAddPressed,
        tooltip: 'Agregar a mis productos',
      ),
      onTap: () {
        // Mostrar diálogo con más detalles
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => ProductBottomSheet(
            product: product,
            onAddPressed: onAddPressed,
          ),
        );
      },
    );
  }
}

class ProductBottomSheet extends StatelessWidget {
  final BeautyProduct product;
  final VoidCallback onAddPressed;

  const ProductBottomSheet({
    Key? key,
    required this.product,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: product.imageUrl != null
                  ? Image.network(
                      product.imageUrl!,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: const Icon(Icons.spa, size: 48),
                      ),
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.spa, size: 48),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Marca
          if (product.brand.isNotEmpty)
            Text(
              product.brand.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          
          const SizedBox(height: 4),
          
          // Nombre
          Text(
            product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          
          const SizedBox(height: 12),
          
          // Categorías
          if (product.categories.isNotEmpty) ...[
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.categories.take(5).map((cat) {
                return Chip(
                  label: Text(cat, style: const TextStyle(fontSize: 11)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          
          // Botón de agregar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onAddPressed();
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar a mis productos'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Botón de ver detalles
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(product: product),
                  ),
                );
              },
              child: const Text('Ver detalles'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.spa_outlined, color: Theme.of(context).colorScheme.outline),
    );
  }
}