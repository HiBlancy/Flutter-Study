// lib/widgets/edit_product_dialog.dart

import 'package:flutter/material.dart';
import '../models/beauty_product.dart';
import '../models/product_list_type.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class EditProductDialog extends StatefulWidget {
  final BeautyProduct product;

  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _notesController;
  late final TextEditingController _periodAfterOpeningController;
  final TextEditingController _newCategoryController = TextEditingController();

  int? _rating;
  DateTime? _expirationDate;
  DateTime? _openedDate;
  late List<String> _categories;
  late ProductListType _selectedListType;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p.name);
    _brandController = TextEditingController(text: p.brand);
    _notesController = TextEditingController(text: p.notes ?? '');
    _periodAfterOpeningController = TextEditingController(
      text: p.periodAfterOpening ?? '',
    );
    _rating = p.rating;
    _expirationDate = p.expirationDate;
    _openedDate = p.openedDate;
    _categories = List.from(p.categories ?? []);
    _selectedListType = ProductListType.fromNullable(p.listType);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _notesController.dispose();
    _periodAfterOpeningController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({
    required DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required ValueChanged<DateTime> onDateSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && mounted) {
      final safeDate = DateTime.utc(picked.year, picked.month, picked.day, 12);
      setState(() => onDateSelected(safeDate));
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

  void _saveProduct() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio')),
      );
      return;
    }

    final hasOpenedDate = _openedDate != null;

    final updatedProduct = BeautyProduct(
      id: widget.product.id,
      barcode: widget.product.barcode,
      name: _nameController.text.trim(),
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      imageUrl: widget.product.imageUrl,
      categories: _categories.isEmpty ? null : _categories,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      rating: _rating,
      listType: _selectedListType.value,
      expirationDate: _expirationDate,
      periodAfterOpening: _periodAfterOpeningController.text.trim().isEmpty
          ? null
          : _periodAfterOpeningController.text.trim(),
      openedDate: _openedDate,
      addedAt: widget.product.addedAt,
      isOpened: hasOpenedDate,
    );

    Navigator.pop(context, updatedProduct);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleBorder = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: theme.colorScheme.surface,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 500,
        ),
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selector de lista
                    _buildListSelector(theme, subtleBorder),
                    const SizedBox(height: 20),
                    
                    // Nombre
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre del producto *',
                      prefixIcon: Icons.spa,
                      hint: 'Ej: Crema hidratante facial',
                      validator: (v) =>
                          v?.trim().isEmpty == true
                              ? 'El nombre es obligatorio'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Marca
                    CustomTextField(
                      controller: _brandController,
                      label: 'Marca',
                      prefixIcon: Icons.branding_watermark,
                      hint: 'Ej: L\'Oréal, Nivea, Garnier',
                    ),
                    const SizedBox(height: 16),
                    
                    // Calificación
                    _buildRatingSection(subtleBorder),
                    const SizedBox(height: 16),
                    
                    // Fecha de caducidad
                    _buildDateSelector(
                      icon: Icons.warning_amber,
                      iconColor: Colors.orange,
                      text: _expirationDate != null
                          ? 'Caducidad: ${_formatDate(_expirationDate!)}'
                          : 'Añadir fecha de caducidad',
                      isActive: _expirationDate != null,
                      borderColor: subtleBorder,
                      onTap: () => _selectDate(
                        initialDate: _expirationDate,
                        firstDate: DateTime.now(),
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 5)),
                        onDateSelected: (date) => _expirationDate = date,
                      ),
                      onClear: () => setState(() => _expirationDate = null),
                    ),
                    const SizedBox(height: 16),
                    
                    // Duración después de abrir
                    CustomTextField(
                      controller: _periodAfterOpeningController,
                      label: 'Duración después de abrir',
                      prefixIcon: Icons.timer,
                      hint: 'Ej: 6 meses, 12M',
                    ),
                    const SizedBox(height: 16),
                    
                    // Categorías
                    _buildCategoriesSection(subtleBorder),
                    const SizedBox(height: 16),
                    
                    // Notas
                    CustomTextField(
                      controller: _notesController,
                      label: 'Notas adicionales',
                      prefixIcon: Icons.note,
                      hint: 'Añade información adicional',
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButtons(subtleBorder),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? theme.colorScheme.surface : theme.colorScheme.primary;
    final fgColor =
        isDark ? Color(0xfff4add8) : theme.colorScheme.onPrimary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: isDark
            ? Border(
                bottom: BorderSide(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Icon(Icons.edit, color: fgColor, size: 24),
          const SizedBox(width: 12),
          Text(
            'Editar producto',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: fgColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.close, color: fgColor),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildListSelector(ThemeData theme, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        color: _selectedListType.color.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lista',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ProductListType.values.map((type) {
                final isSelected = _selectedListType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedListType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? type.color
                            : type.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: type.color,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            type.icon,
                            color: isSelected ? Colors.white : type.color,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            type.label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : type.color,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection(Color borderColor) {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calificación',
                style: TextStyle(fontSize: 12, color: subtleText),
              ),
              if (_rating != null)
                TextButton(
                  onPressed: () => setState(() => _rating = null),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Limpiar',
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.error),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              ...List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < (_rating ?? 0) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 8),
              if (_rating != null)
                Text('$_rating/5', style: theme.textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector({
    required IconData icon,
    required Color iconColor,
    required String text,
    required bool isActive,
    required Color borderColor,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isActive
                      ? theme.colorScheme.onSurface
                      : subtleText,
                ),
              ),
            ),
            if (isActive)
              IconButton(
                icon: Icon(Icons.clear, size: 20, color: theme.colorScheme.error),
                onPressed: onClear,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Eliminar fecha',
              ),
            Icon(Icons.calendar_today, color: subtleText),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(Color borderColor) {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final chipBg = theme.colorScheme.onSurface.withValues(alpha: 0.08);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías',
                style: TextStyle(fontSize: 12, color: subtleText),
              ),
              if (_categories.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _categories.clear()),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Eliminar todas',
                    style:
                        TextStyle(fontSize: 11, color: theme.colorScheme.error),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories
                .map(
                  (cat) => Chip(
                    label: Text(cat, style: theme.textTheme.bodySmall),
                    backgroundColor: chipBg,
                    side: BorderSide.none,
                    deleteIcon:
                        Icon(Icons.close, size: 18, color: theme.colorScheme.error),
                    onDeleted: () => setState(() => _categories.remove(cat)),
                  ),
                )
                .toList(),
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
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                onPressed: _addCategory,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor)),
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
              text: 'Guardar',
              onPressed: _saveProduct,
              type: ButtonType.primary,
              size: ButtonSize.full,
              icon: Icons.save,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}