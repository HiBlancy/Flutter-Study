import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
import '../models/beauty_product.dart';
import '../services/product_service.dart';
import '../widgets/edit_product_dialog.dart';
import '../widgets/custom_button.dart';

class ProductScreen extends StatefulWidget {
  final BeautyProduct product;
  final bool isFromSearch;

  const ProductScreen({
    super.key, 
    required this.product,
    this.isFromSearch = false,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _productService = ProductService();
  bool _isAdding = false;
  bool _isEditing = false;
  bool _isDeleting = false;
  late BeautyProduct _currentProduct;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
  }

  Future<void> _addToMyProducts() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar producto'),
        content: Text('¿Quieres agregar "${_currentProduct.name}" a tu lista de productos?'),
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

    if (confirm != true) return;

    setState(() => _isAdding = true);
    
    final added = await _productService.addProductToHave(_currentProduct);
    
    setState(() => _isAdding = false);
    
    if (added != null && mounted) {
      setState(() {
        _currentProduct = added;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ "${_currentProduct.name}" agregado a tu lista'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      if (widget.isFromSearch) {
        Navigator.pop(context);
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar el producto. Intenta de nuevo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _editProduct() async {
    final editedProduct = await showDialog<BeautyProduct>(
      context: context,
      builder: (context) => EditProductDialog(product: _currentProduct),
    );

    if (editedProduct != null && editedProduct != _currentProduct) {
      setState(() => _isEditing = true);
      
      final updated = await _productService.updateProduct(
        _currentProduct.id!,
        editedProduct.toBackendJson(),
      );
      
      setState(() => _isEditing = false);
      
      if (updated != null && mounted) {
        setState(() {
          _currentProduct = updated;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Producto actualizado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        
        // ✅ Devolver el producto actualizado para que la pantalla anterior lo sepa
        Navigator.pop(context, updated);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar el producto'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteProduct() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Eliminar producto'),
      content: Text('¿Estás seguro de que quieres eliminar "${_currentProduct.name}" de tu lista?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  setState(() => _isDeleting = true);
  
  final deleted = await _productService.deleteProduct(_currentProduct.id!);
  
  setState(() => _isDeleting = false);
  
  if (deleted && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ "${_currentProduct.name}" eliminado de tu lista'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // ✅ Devolver true para indicar que se eliminó
    Navigator.pop(context, true);
  } else if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Error al eliminar el producto. Intenta de nuevo.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final isProductSaved = _currentProduct.id != null;
    final showAddButton = widget.isFromSearch && !isProductSaved;

    return CustomAppBar(
      title: _currentProduct.name,
      showDrawer: false,
      showBackButton: true,
      actions: [
        // Botón de editar (solo si el producto está guardado)
        if (isProductSaved)
          IconButton(
            icon: _isEditing 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.edit),
            onPressed: _isEditing ? null : _editProduct,
            tooltip: 'Editar producto',
          ),
        // Botón de agregar (solo si viene de búsqueda)
        if (showAddButton)
          IconButton(
            icon: _isAdding 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            onPressed: _isAdding ? null : _addToMyProducts,
            tooltip: 'Agregar a mis productos',
          ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _currentProduct.imageUrl != null && _currentProduct.imageUrl!.isNotEmpty
                    ? Image.network(
                        _currentProduct.imageUrl!,
                        height: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const _PlaceholderImage(),
                      )
                    : const _PlaceholderImage(),
              ),
            ),

            const SizedBox(height: 24),

            // Marca
            if (_currentProduct.brand.isNotEmpty)
              Text(
                _currentProduct.brand.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 1.2,
                ),
              ),

            const SizedBox(height: 6),

            // Nombre
            Text(
              _currentProduct.name.isNotEmpty ? _currentProduct.name : 'Sin nombre',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Rating (solo si existe)
            if (_currentProduct.rating != null) ...[
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < _currentProduct.rating! ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                  const SizedBox(width: 8),
                  Text(
                    '${_currentProduct.rating}/5',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Código de barras
            _InfoRow(
              icon: Icons.qr_code,
              label: 'Código de barras',
              value: _currentProduct.barcode.isNotEmpty ? _currentProduct.barcode : '—',
            ),

            // Campos adicionales (solo si existen o si el producto está guardado)
            if (isProductSaved) ...[
              if (_currentProduct.addedAt != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Agregado',
                  value: _formatDate(_currentProduct.addedAt!),
                ),
              ],

              if (_currentProduct.expirationDate != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.warning_amber,
                  label: 'Caducidad',
                  value: _formatDate(_currentProduct.expirationDate!),
                ),
              ],

              if (_currentProduct.periodAfterOpening != null && _currentProduct.periodAfterOpening!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.timer,
                  label: 'Duración después de abrir',
                  value: _currentProduct.periodAfterOpening!,
                ),
              ],

              if (_currentProduct.openedDate != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.open_in_new,
                  label: 'Abierto el',
                  value: _formatDate(_currentProduct.openedDate!),
                ),
              ],

              if (_currentProduct.notes != null && _currentProduct.notes!.isNotEmpty) ...[
                const Divider(height: 32),
                Text(
                  'Notas',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _currentProduct.notes!,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ],

            const Divider(height: 32),

            // Categorías
            if (_currentProduct.categories.isNotEmpty) ...[
              Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _currentProduct.categories
                    .take(6)
                    .map((cat) => Chip(
                          label: Text(cat, style: const TextStyle(fontSize: 12)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),  
            ],

            const SizedBox(height: 24),

            // Botón de eliminar (solo si el producto está guardado)
            if (isProductSaved) ...[
              CustomButton(
                text: 'Eliminar producto',
                onPressed: _isDeleting ? () {} : _deleteProduct,
                type: ButtonType.danger,
                size: ButtonSize.full,
                icon: Icons.delete,
                isLoading: _isDeleting,
                isEnabled: !_isDeleting,
              ),
              const SizedBox(height: 12),
            ],

            // Botón de agregar usando CustomButton
            if (showAddButton) ...[
              CustomButton(
                text: 'Agregar a mis productos',
                onPressed: _isAdding ? () {} : _addToMyProducts,
                type: ButtonType.primary,
                size: ButtonSize.full,
                icon: Icons.add,
                isLoading: _isAdding,
                isEnabled: !_isAdding,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.spa_outlined,
        size: 72,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}