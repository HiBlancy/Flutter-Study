// lib/widgets/edit_product_dialog.dart
import 'package:flutter/material.dart';
import '../models/beauty_product.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class EditProductDialog extends StatefulWidget {
  final BeautyProduct product;

  const EditProductDialog({
    super.key,
    required this.product,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _notesController;
  late TextEditingController _barcodeController;
  late TextEditingController _periodAfterOpeningController;
  
  int? _rating;
  DateTime? _expirationDate;
  DateTime? _openedDate;
  List<String> _categories = [];
  final TextEditingController _newCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _brandController = TextEditingController(text: widget.product.brand);
    _notesController = TextEditingController(text: widget.product.notes ?? '');
    _barcodeController = TextEditingController(text: widget.product.barcode);
    _periodAfterOpeningController = TextEditingController(text: widget.product.periodAfterOpening ?? '');
    _rating = widget.product.rating;
    _expirationDate = widget.product.expirationDate;
    _openedDate = widget.product.openedDate;
    _categories = List.from(widget.product.categories);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _notesController.dispose();
    _barcodeController.dispose();
    _periodAfterOpeningController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && mounted) {
      setState(() => _expirationDate = picked);
    }
  }

  Future<void> _selectOpenedDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _openedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _openedDate = picked);
    }
  }

  void _addCategory() {
    if (_newCategoryController.text.trim().isNotEmpty) {
      setState(() {
        _categories.add(_newCategoryController.text.trim());
        _newCategoryController.clear();
      });
    }
  }

  void _removeCategory(String category) {
    setState(() {
      _categories.remove(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 500,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary),
                  const SizedBox(width: 12),
                  Text(
                    'Editar producto',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // Formulario
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre (requerido) - usando CustomTextField
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre del producto *',
                      prefixIcon: Icons.spa,
                      hint: 'Ej: Crema hidratante facial',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Marca - usando CustomTextField
                    CustomTextField(
                      controller: _brandController,
                      label: 'Marca',
                      prefixIcon: Icons.branding_watermark,
                      hint: 'Ej: L\'Oréal, Nivea, Garnier',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    // Código de barras (solo lectura)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                      ),
                      child: TextFormField(
                        controller: _barcodeController,
                        decoration: InputDecoration(
                          labelText: 'Código de barras',
                          prefixIcon: const Icon(Icons.qr_code),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        readOnly: true,
                        enabled: false,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rating (estrellas)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Calificación',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              ...List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < (_rating ?? 0) ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _rating = index + 1;
                                    });
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                );
                              }),
                              const SizedBox(width: 8),
                              if (_rating != null)
                                Text(
                                  '$_rating/5',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fecha de caducidad
                    InkWell(
                      onTap: () => _selectExpirationDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber, color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _expirationDate != null
                                    ? 'Caducidad: ${_formatDate(_expirationDate!)}'
                                    : 'Añadir fecha de caducidad',
                                style: TextStyle(
                                  color: _expirationDate != null ? Colors.black : Colors.grey,
                                ),
                              ),
                            ),
                            if (_expirationDate != null)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () => setState(() => _expirationDate = null),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Periodo después de abrir - usando CustomTextField
                    CustomTextField(
                      controller: _periodAfterOpeningController,
                      label: 'Duración después de abrir',
                      prefixIcon: Icons.timer,
                      hint: 'Ej: 6 meses, 12M, 24M',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    // Fecha de apertura
                    InkWell(
                      onTap: () => _selectOpenedDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.open_in_new),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _openedDate != null
                                    ? 'Abierto el: ${_formatDate(_openedDate!)}'
                                    : 'Añadir fecha de apertura',
                                style: TextStyle(
                                  color: _openedDate != null ? Colors.black : Colors.grey,
                                ),
                              ),
                            ),
                            if (_openedDate != null)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () => setState(() => _openedDate = null),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categorías
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Categorías',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ..._categories.map((cat) => Chip(
                                label: Text(cat),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => _removeCategory(cat),
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _newCategoryController,
                                  label: '',
                                  prefixIcon: Icons.category,
                                  hint: 'Nueva categoría',
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                onPressed: _addCategory,
                                color: Theme.of(context).colorScheme.primary,
                                iconSize: 32,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notas - usando CustomTextField
                    CustomTextField(
                      controller: _notesController,
                      label: 'Notas adicionales',
                      prefixIcon: Icons.note,
                      hint: 'Añade información adicional sobre el producto...',
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ),

            // Botones de acción usando CustomButton
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancelar',
                      onPressed: () => Navigator.pop(context),
                      type: ButtonType.secondary,
                      size: ButtonSize.full,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Guardar cambios',
                      onPressed: () {
                        // Validar campos requeridos
                        if (_nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('El nombre es obligatorio')),
                          );
                          return;
                        }

                        final updatedProduct = widget.product.copyWith(
                          name: _nameController.text.trim(),
                          brand: _brandController.text.trim(),
                          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                          rating: _rating,
                          expirationDate: _expirationDate,
                          periodAfterOpening: _periodAfterOpeningController.text.trim().isEmpty 
                              ? null 
                              : _periodAfterOpeningController.text.trim(),
                          openedDate: _openedDate,
                          categories: _categories,
                        );

                        Navigator.pop(context, updatedProduct);
                      },
                      type: ButtonType.primary,
                      size: ButtonSize.full,
                      icon: Icons.save,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}