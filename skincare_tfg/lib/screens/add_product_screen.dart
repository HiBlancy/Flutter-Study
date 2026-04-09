import 'package:dueglow/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../models/beauty_product.dart';
import '../services/product_service.dart';
import '../widgets/main_toolbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  // Controladores del formulario
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _paoController = TextEditingController();
  final _notesController = TextEditingController();
  final _newCategoryController = TextEditingController();

  DateTime? _expirationDate;
  DateTime? _openedDate;
  final List<String> _categories = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _paoController.dispose();
    _notesController.dispose();
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) setState(() => onDateSelected(picked));
  }

  void _addCategory() {
    final newCat = _newCategoryController.text.trim();
    if (newCat.isNotEmpty && !_categories.contains(newCat)) {
      setState(() {
        _categories.add(newCat);
        _newCategoryController.clear();
      });
    }
  }

  Future<void> _saveProductManually() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Creamos el producto nuevo. Por defecto se añade a la lista de "Tengo" ('have')
      final newProduct = BeautyProduct(
        barcode: _barcodeController.text.trim(), // Puede estar vacío si es manual
        name: _nameController.text.trim(),
        brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
        categories: _categories.isEmpty ? null : _categories,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        periodAfterOpening: _paoController.text.trim().isEmpty ? null : _paoController.text.trim(),
        expirationDate: _expirationDate,
        openedDate: _openedDate,
        listType: 'have', 
        addedAt: DateTime.now(),
        isOpened: _openedDate != null,
      );

      final addedProduct = await _productService.addProductToHave(newProduct);

      if (mounted) {
        setState(() => _isLoading = false);
        
        if (addedProduct != null) {
          _showSnackBar('✓ Producto añadido correctamente');
          _clearForm();
        } else {
          _showSnackBar('Error al añadir el producto', isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Error: ${e.toString()}', isError: true);
      }
    }
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _brandController.clear();
      _barcodeController.clear();
      _paoController.clear();
      _notesController.clear();
      _newCategoryController.clear();
      _expirationDate = null;
      _openedDate = null;
      _categories.clear();
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? theme.colorScheme.error : theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- INTERFAZ ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleBorder = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    return CustomAppBar(
      title: 'Añadir Producto', // Traducir con l10n.addProduct
      showDrawer: true, // Pon true si tienes el menú lateral aquí, o false si no
      showBackButton: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ZONA DE ACCIONES RÁPIDAS
            Text(
              'Acciones rápidas',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.qr_code_scanner,
                    title: 'Escanear',
                    subtitle: 'Código de barras',
                    onTap: () {
                      // Usa el enrutamiento que tengas en tu main.dart
                      Navigator.pushNamed(context, AppConstants.routeScan); 
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.search,
                    title: 'Buscar',
                    subtitle: 'Según marco o tipo',
                    onTap: () {
                      Navigator.pushNamed(context, AppConstants.routeSearch);
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            Row(
              children: [
                Expanded(child: Divider(color: subtleBorder)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'O añadir manualmente',
                    style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
                  ),
                ),
                Expanded(child: Divider(color: subtleBorder)),
              ],
            ),
            
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: theme.brightness == Brightness.dark 
                    ? Border.all(color: subtleBorder) 
                    : null,
                boxShadow: theme.brightness == Brightness.light
                    ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
                    : [],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Nombre del producto *',
                      prefixIcon: Icons.spa,
                      hint: 'Ej: Crema hidratante facial',
                      validator: (v) => v?.trim().isEmpty == true ? 'El nombre es obligatorio' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _brandController,
                      label: 'Marca',
                      prefixIcon: Icons.branding_watermark,
                      hint: 'Ej: L\'Oréal, Nivea, Garnier',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _barcodeController,
                      label: 'Código de barras (Opcional)',
                      prefixIcon: Icons.qr_code,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
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
                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        onDateSelected: (date) => _expirationDate = date,
                      ),
                      onClear: () => setState(() => _expirationDate = null),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _paoController,
                      label: 'Duración tras abrir (PAO)',
                      prefixIcon: Icons.timer,
                      hint: 'Ej: 6 meses, 12M',
                    ),
                    const SizedBox(height: 16),
                    _buildDateSelector(
                      icon: Icons.open_in_new,
                      iconColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      text: _openedDate != null
                          ? 'Abierto el: ${_formatDate(_openedDate!)}'
                          : 'Añadir fecha de apertura',
                      isActive: _openedDate != null,
                      borderColor: subtleBorder,
                      onTap: () => _selectDate(
                        initialDate: _openedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
                        lastDate: DateTime.now(),
                        onDateSelected: (date) => _openedDate = date,
                      ),
                      onClear: () => setState(() => _openedDate = null),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoriesSection(subtleBorder),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _notesController,
                      label: 'Notas adicionales',
                      prefixIcon: Icons.note,
                      hint: 'Ej: Usar solo de noche',
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Guardar Producto',
                      onPressed: _saveProductManually,
                      isLoading: _isLoading,
                      type: ButtonType.primary,
                      size: ButtonSize.full,
                      icon: Icons.save,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40), // Espacio extra al final para el scroll
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? theme.colorScheme.surface : theme.colorScheme.primary.withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isDark ? BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
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
                  color: isActive ? theme.colorScheme.onSurface : subtleText,
                ),
              ),
            ),
            if (isActive)
              IconButton(
                icon: Icon(Icons.clear, size: 20, color: theme.colorScheme.error),
                onPressed: onClear,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
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
    final chipBg = theme.colorScheme.onSurface.withValues(alpha: 0.05);

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
              Text('Categorías', style: TextStyle(fontSize: 12, color: subtleText)),
              if (_categories.isNotEmpty)
                TextButton(
                  onPressed: () => setState(() => _categories.clear()),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Eliminar todas', style: TextStyle(fontSize: 11, color: theme.colorScheme.error)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories
                .map((cat) => Chip(
                      label: Text(cat, style: theme.textTheme.bodySmall),
                      backgroundColor: chipBg,
                      side: BorderSide.none,
                      deleteIcon: Icon(Icons.close, size: 16, color: theme.colorScheme.error),
                      onDeleted: () => setState(() => _categories.remove(cat)),
                    ))
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
                  hint: 'Nueva categoría (ej. Facial)',
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.add_circle, color: theme.colorScheme.primary),
                onPressed: _addCategory,
                iconSize: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}