// lib/screens/product_screen.dart (actualizado)
import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
import '../models/beauty_product.dart';
import '../services/product_service.dart';

class ProductScreen extends StatefulWidget {
  final BeautyProduct product;
  final bool isFromSearch; // Para saber si viene de búsqueda externa

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

  Future<void> _addToMyProducts() async {
    setState(() => _isAdding = true);
    
    final added = await _productService.addProductToHave(widget.product);
    
    setState(() => _isAdding = false);
    
    if (added != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Producto agregado a tu lista'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar el producto'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: widget.product.name,
      showDrawer: false,
      showBackButton: true,
      actions: widget.isFromSearch && widget.product.id == null
          ? [
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
            ]
          : null,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: widget.product.imageUrl != null && widget.product.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.product.imageUrl!,
                        height: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const _PlaceholderImage(),
                      )
                    : const _PlaceholderImage(),
              ),
            ),

            const SizedBox(height: 24),

            // Marca
            if (widget.product.brand.isNotEmpty)
              Text(
                widget.product.brand.toUpperCase(),
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
              widget.product.name.isNotEmpty ? widget.product.name : 'Sin nombre',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Rating (solo si existe)
            if (widget.product.rating != null) ...[
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < widget.product.rating! ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.product.rating}/5',
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
              value: widget.product.barcode.isNotEmpty ? widget.product.barcode : '—',
            ),

            if (widget.product.id != null) ...[
              // Solo mostrar estos campos si el producto ya está guardado
              if (widget.product.addedAt != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Agregado',
                  value: _formatDate(widget.product.addedAt!),
                ),
              ],

              if (widget.product.expirationDate != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.warning_amber,
                  label: 'Caducidad',
                  value: _formatDate(widget.product.expirationDate!),
                ),
              ],

              if (widget.product.periodAfterOpening != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.timer,
                  label: 'Duración después de abrir',
                  value: widget.product.periodAfterOpening!,
                ),
              ],

              if (widget.product.openedDate != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.open_in_new,
                  label: 'Abierto el',
                  value: _formatDate(widget.product.openedDate!),
                ),
              ],

              if (widget.product.notes != null && widget.product.notes!.isNotEmpty) ...[
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
                  widget.product.notes!,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ],

            const Divider(height: 32),

            // Categorías
            if (widget.product.categories.isNotEmpty) ...[
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
                children: widget.product.categories
                    .take(6)
                    .map((cat) => Chip(
                          label: Text(cat, style: const TextStyle(fontSize: 12)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],

            // Botón de agregar si viene de búsqueda (al final)
            if (widget.isFromSearch && widget.product.id == null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isAdding ? null : _addToMyProducts,
                  icon: _isAdding 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: const Text('Agregar a mis productos'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
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