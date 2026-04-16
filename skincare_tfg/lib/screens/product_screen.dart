import 'package:flutter/material.dart';
import '../models/beauty_product.dart';
import '../models/product_list_type.dart';
import '../services/product_service.dart';
import '../widgets/edit_product_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/warning_dialog.dart';

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
  late BeautyProduct _currentProduct;

  final Map<String, bool> _loadingStates = {
    'adding': false,
    'editing': false,
    'deleting': false,
    'opening': false,
    'closing': false,
    'calculating': false,
    'finishing': false,
    'changingList': false,
  };

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
  }

  void _setLoading(String key, bool value) {
    if (mounted) {
      setState(() => _loadingStates[key] = value);
    }
  }

  bool _isLoading(String key) => _loadingStates[key] == true;

  Future<void> _showMessage(String message, {bool isError = false}) async {
    if (!mounted) return;

    final theme = Theme.of(context);

    if (isError) {
      await WarningDialog.showInfo(
        context: context,
        title: 'Error',
        content: message,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: theme.colorScheme.onPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: theme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  Future<bool> _confirmAction(
    String title,
    String content, {
    bool isDanger = false,
  }) async {
    return await WarningDialog.show(
      context: context,
      title: title,
      content: content,
      confirmText: isDanger ? 'Eliminar' : 'Aceptar',
      isDanger: isDanger,
    );
  }

  Future<void> _executeAction({
    required Future<BeautyProduct?> Function() action,
    required String successMessage,
    required String loadingKey,
    VoidCallback? onSuccess,
  }) async {
    _setLoading(loadingKey, true);
    final result = await action();
    _setLoading(loadingKey, false);

    if (result != null) {
      setState(() => _currentProduct = result);
      await _showMessage(successMessage);
      onSuccess?.call();
    } else {
      await _showMessage('Error al realizar la operación', isError: true);
    }
  }

  // --- CAMBIAR DE LISTA ---

  Future<void> _changeProductList() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentListType = ProductListType.fromNullable(
      _currentProduct.listType,
    );
    final newListType = await showDialog<ProductListType>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark
              ? BorderSide(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                )
              : BorderSide.none,
        ),
        title: Row(
          children: [
            Icon(Icons.swap_horiz, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'Cambiar a otra lista',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ProductListType.values.map((type) {
              final isCurrentType = currentListType == type;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  border: isCurrentType
                      ? Border.all(color: type.color, width: 2)
                      : Border.all(
                          color: isDark
                              ? type.color.withValues(alpha: 0.2)
                              : type.color.withValues(alpha: 0.15),
                        ),
                  borderRadius: BorderRadius.circular(12),
                  color: isCurrentType
                      ? type.color.withValues(alpha: 0.15)
                      : Colors.transparent,
                ),
                child: ListTile(
                  leading: Icon(type.icon, color: type.color, size: 24),
                  title: Text(
                    type.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isCurrentType
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isCurrentType
                          ? type.color
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  trailing: isCurrentType
                      ? Icon(Icons.check_circle, color: type.color, size: 24)
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onTap: () => Navigator.pop(context, type),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );

    if (newListType != null && newListType != currentListType) {
      await _executeAction(
        action: () => _productService.updateProduct(_currentProduct.id!, {
          'listType': newListType.value,
        }),
        successMessage: '✓ Producto movido a "${newListType.label}"',
        loadingKey: 'changingList',
      );
    }
  }

  // --- ACCIONES PRINCIPALES (simplificadas) ---

  Future<void> _addToMyProducts() async {
    if (!await _confirmAction(
      'Agregar producto',
      '¿Quieres agregar "${_currentProduct.name}" a tu lista de productos?',
    )) {
      return;
    }

    await _executeAction(
      action: () => _productService.addProductToHave(_currentProduct),
      successMessage: '✓ "${_currentProduct.name}" agregado a tu lista',
      loadingKey: 'adding',
      onSuccess: () {
        if (widget.isFromSearch && mounted) Navigator.pop(context);
      },
    );
  }

  Future<void> _editProduct() async {
    final editedProduct = await showDialog<BeautyProduct>(
      context: context,
      builder: (context) => EditProductDialog(
        product: _currentProduct, // ✅ Usa _currentProduct, no product
        onProductUpdated: (updatedProduct) {
          // Actualizar directamente el producto actual
          setState(() {
            _currentProduct = updatedProduct;
          });
        },
      ),
    );

    if (editedProduct != null && editedProduct != _currentProduct) {
      final updatedData = <String, dynamic>{
        'name': editedProduct.name,
        'brand': editedProduct.brand,
        'categories': editedProduct.categories,
        'notes': editedProduct.notes,
        'rating': editedProduct.rating,
        'periodAfterOpening': editedProduct.periodAfterOpening,
        'expirationDate': editedProduct.expirationDate?.toIso8601String(),
        'openedDate': editedProduct.openedDate?.toIso8601String(),
        'listType': editedProduct.listType,
      };

      await _executeAction(
        action: () =>
            _productService.updateProduct(_currentProduct.id!, updatedData),
        successMessage: '✓ Producto actualizado correctamente',
        loadingKey: 'editing',
      );
    }
  }

  Future<void> _deleteProduct() async {
    if (!await _confirmAction(
      'Eliminar producto',
      '¿Estás seguro de que quieres eliminar "${_currentProduct.name}" de tu lista?',
      isDanger: true,
    )) {
      return;
    }

    _setLoading('deleting', true);
    final deleted = await _productService.deleteProduct(_currentProduct.id!);
    _setLoading('deleting', false);

    if (deleted) {
      await _showMessage('✓ "${_currentProduct.name}" eliminado de tu lista');
      if (mounted) Navigator.pop(context, true);
    } else {
      await _showMessage('Error al eliminar el producto', isError: true);
    }
  }

  Future<void> _markAsFinished() async {
    await _showMessage('Funcionalidad "Producto acabado" en desarrollo');
  }

  Future<void> _markAsOpened() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedOption = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark
              ? BorderSide(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                )
              : BorderSide.none,
        ),
        title: Row(
          children: [
            Icon(Icons.open_in_new, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text('Abrir producto', style: theme.textTheme.titleLarge),
          ],
        ),
        contentPadding: const EdgeInsets.only(top: 16, bottom: 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogListTile(
              icon: Icons.today,
              title: 'Hoy',
              onTap: () => Navigator.pop(context, 'hoy'),
            ),
            _DialogListTile(
              icon: Icons.calendar_month,
              title: 'Otra fecha...',
              onTap: () => Navigator.pop(context, 'otra'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );

    if (selectedOption == null) return;

    DateTime? finalDate;

    if (selectedOption == 'hoy') {
      finalDate = DateTime.now();
    } else if (selectedOption == 'otra') {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(colorScheme: theme.colorScheme),
            child: child!,
          );
        },
      );

      if (pickedDate == null) return;
      finalDate = DateTime.utc(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        12,
        0,
        0,
      );
    }

    await _executeAction(
      action: () => _productService.markAsOpened(
        _currentProduct.id!,
        openedDate: finalDate,
      ),
      successMessage: '✓ Producto marcado como abierto',
      loadingKey: 'opening',
    );
  }

  Future<void> _markAsClosed() async {
    await _executeAction(
      action: () => _productService.markAsClosed(_currentProduct.id!),
      successMessage: '✓ Producto marcado como cerrado',
      loadingKey: 'closing',
    );
  }

  Future<void> _calculateExpiration() async {
    await _executeAction(
      action: () => _productService.calculateExpiration(_currentProduct.id!),
      successMessage: '✓ Fecha de caducidad calculada',
      loadingKey: 'calculating',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isProductSaved = _currentProduct.id != null;
    final showAddButton = widget.isFromSearch || !isProductSaved;
    final currentListType = isProductSaved
        ? ProductListType.fromNullable(_currentProduct.listType)
        : null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Color(0xff3a1a2f) : theme.colorScheme.surface,
        foregroundColor: isDark
            ? Color(0xfff4add8)
            : theme.colorScheme.onPrimary,
        title: Text(
          'DueGlow',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.displaySmall?.copyWith(
            color: isDark ? Color(0xfff4add8) : theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            fontStyle: FontStyle.italic
          ),
        ),
        actions: [
          if (isProductSaved)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _isLoading('editing') ? null : _editProduct,
              tooltip: 'Editar producto',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(theme),
            const SizedBox(height: 24),
            if (isProductSaved) ...[
              _buildProductListSection(theme, currentListType),
              const SizedBox(height: 24),
            ],
            _buildProductInfo(theme),
            const SizedBox(height: 24),
            if (_currentProduct.categories?.isNotEmpty == true)
              _buildCategories(theme),
            const SizedBox(height: 24),
            _buildScrollableButtons(isProductSaved, showAddButton),
            const SizedBox(height: 128),
            if (isProductSaved)
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Eliminar producto',
                  onPressed: _isLoading('deleting') ? () {} : _deleteProduct,
                  type: ButtonType.danger,
                  size: ButtonSize.full,
                  icon: Icons.delete_outline,
                  isLoading: _isLoading('deleting'),
                  isEnabled: !_isLoading('deleting'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child:
              _currentProduct.imageUrl != null &&
                  _currentProduct.imageUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _currentProduct.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _PlaceholderImage(),
                  ),
                )
              : const _PlaceholderImage(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentProduct.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (_currentProduct.brand?.isNotEmpty == true)
                Text(
                  _currentProduct.brand!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (_currentProduct.rating != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        index < _currentProduct.rating!
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_currentProduct.rating}/5',
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductListSection(
    ThemeData theme,
    ProductListType? currentListType,
  ) {
    if (currentListType == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: currentListType.color.withValues(alpha: 0.1),
        border: Border.all(
          color: currentListType.color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(currentListType.icon, color: currentListType.color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lista actual',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentListType.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: currentListType.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, color: currentListType.color),
            onPressed: _isLoading('changingList') ? null : _changeProductList,
            tooltip: 'Cambiar lista',
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ThemeData theme) {
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final isReallyOpened =
        _currentProduct.isOpened == true && _currentProduct.openedDate != null;
    final hasExpirationInfo =
        _currentProduct.expirationDate != null ||
        (_currentProduct.periodAfterOpening?.isNotEmpty == true);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_currentProduct.addedAt != null) ...[
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Agregado',
              value: _formatDate(_currentProduct.addedAt!),
            ),
            const SizedBox(height: 12),
          ],
          if (_currentProduct.expirationDate != null) ...[
            _InfoRow(
              icon: Icons.warning_amber,
              label: 'Caducidad',
              value: _formatDate(_currentProduct.expirationDate!),
            ),
            const SizedBox(height: 12),
          ],
          if (isReallyOpened && _currentProduct.openedDate != null) ...[
            _InfoRow(
              icon: Icons.open_in_new,
              label: 'Abierto el',
              value: _formatDate(_currentProduct.openedDate!),
            ),
            const SizedBox(height: 12),
          ],
          if (isReallyOpened &&
              _currentProduct.periodAfterOpening?.isNotEmpty == true) ...[
            _InfoRow(
              icon: Icons.timer,
              label: 'Duración después de abrir',
              value: _currentProduct.periodAfterOpening!,
            ),
            const SizedBox(height: 12),
          ],
          if (isReallyOpened && !hasExpirationInfo)
            _buildExpirationWarning(theme),
          if (_currentProduct.notes?.isNotEmpty == true) ...[
            const Divider(height: 24),
            Text(
              'Notas',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: subtleText,
              ),
            ),
            const SizedBox(height: 8),
            Text(_currentProduct.notes!, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }

  Widget _buildExpirationWarning(ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;
    final warningColor = isDarkMode ? Colors.orange[300]! : Colors.orange[800]!;
    final bgColor = Colors.orange.withValues(alpha: 0.15);
    final borderColor = warningColor.withValues(alpha: 0.3);

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: warningColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚠️ Sin información de caducidad',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: warningColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Edita el producto para añadir su duración después de abierto (ej: "6M") o una fecha de caducidad.',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(ThemeData theme) {
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final chipBg = theme.colorScheme.onSurface.withValues(alpha: 0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorías',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: subtleText,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _currentProduct.categories!
              .take(6)
              .map(
                (cat) => Chip(
                  label: Text(cat, style: theme.textTheme.bodySmall),
                  backgroundColor: chipBg,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildScrollableButtons(bool isProductSaved, bool showAddButton) {
    final isReallyOpened =
        _currentProduct.isOpened == true && _currentProduct.openedDate != null;
    final canCalculateExpiration =
        isReallyOpened &&
        _currentProduct.periodAfterOpening?.isNotEmpty == true &&
        _currentProduct.expirationDate == null;

    return Column(
      children: [
        if (showAddButton) ...[
          CustomButton(
            text: 'Agregar a mis productos',
            onPressed: _isLoading('adding') ? () {} : _addToMyProducts,
            type: ButtonType.primary,
            size: ButtonSize.full,
            icon: Icons.add,
            isLoading: _isLoading('adding'),
            isEnabled: !_isLoading('adding'),
          ),
          const SizedBox(height: 12),
        ],
        if (isProductSaved && !isReallyOpened) ...[
          CustomButton(
            text: 'Abrir producto',
            onPressed: _isLoading('opening') ? () {} : _markAsOpened,
            type: ButtonType.primary,
            size: ButtonSize.full,
            icon: Icons.open_in_new,
            isLoading: _isLoading('opening'),
            isEnabled: !_isLoading('opening') && !_isLoading('editing'),
          ),
          const SizedBox(height: 12),
        ],
        if (isProductSaved && isReallyOpened) ...[
          CustomButton(
            text: 'Cerrar producto',
            onPressed: _isLoading('closing') ? () {} : _markAsClosed,
            type: ButtonType.secondary,
            size: ButtonSize.full,
            icon: Icons.close,
            isLoading: _isLoading('closing'),
            isEnabled: !_isLoading('closing') && !_isLoading('editing'),
          ),
          const SizedBox(height: 12),
        ],
        if (canCalculateExpiration) ...[
          CustomButton(
            text: 'Calcular caducidad',
            onPressed: _isLoading('calculating') ? () {} : _calculateExpiration,
            type: ButtonType.secondary,
            size: ButtonSize.full,
            icon: Icons.calculate,
            isLoading: _isLoading('calculating'),
            isEnabled: !_isLoading('calculating') && !_isLoading('editing'),
          ),
          const SizedBox(height: 12),
        ],
        if (isProductSaved) ...[
          CustomButton(
            text: 'Producto acabado',
            onPressed: _isLoading('finishing') ? () {} : _markAsFinished,
            type: ButtonType.secondary,
            size: ButtonSize.full,
            icon: Icons.check_circle_outline,
            isLoading: _isLoading('finishing'),
            isEnabled: !_isLoading('finishing') && !_isLoading('editing'),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

// --- COMPONENTES REUTILIZABLES ---

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleIcon = theme.colorScheme.onSurface.withValues(alpha: 0.5);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Row(
      children: [
        Icon(icon, size: 18, color: subtleIcon),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontSize: 13, color: subtleText)),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
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
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.spa_outlined,
        size: 48,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
      ),
    );
  }
}

class _DialogListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DialogListTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.bodyMedium),
      onTap: onTap,
    );
  }
}
