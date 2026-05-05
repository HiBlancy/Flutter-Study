import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/beauty_product.dart';
import '../models/product_list_type.dart';
import '../models/routine_model.dart';
import '../services/product_service.dart';
import '../services/routine_service.dart';
import '../widgets/edit_product_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/warning_dialog.dart';
import '../l10n/app_localizations.dart';

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
  final RoutineService _routineService = RoutineService();
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
    'addingToRoutine': false,
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

  List<String> get _validCategories {
    final categories = _currentProduct.categories;
    if (categories == null) return const [];
    return categories
        .map((category) => category.trim())
        .where((category) => category.isNotEmpty)
        .toList();
  }

  Future<void> _showMessage(String message, {bool isError = false}) async {
    if (!mounted) return;

    final theme = Theme.of(context);

    if (isError) {
      await WarningDialog.showInfo(
        context: context,
        title: AppLocalizations.of(context)!.errorTitle,
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
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
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
      confirmText: isDanger
          ? AppLocalizations.of(context)!.delete
          : AppLocalizations.of(context)!.accept,
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
      await _showMessage(AppLocalizations.of(context)!.errorPerformingOperation, isError: true);
    }
  }



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
              AppLocalizations.of(context)!.changeToAnotherList,
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
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );

    if (newListType != null && newListType != currentListType) {
      final updateData = <String, dynamic>{
        'listType': newListType.value,
      };
      if (newListType == ProductListType.used) {
        updateData['finishedDate'] = DateTime.now().toIso8601String();
      }

      await _executeAction(
        action: () => _productService.updateProduct(_currentProduct.id!, updateData),
        successMessage: AppLocalizations.of(context)!.productMovedToList(newListType.label),
        loadingKey: 'changingList',
      );
    }
  }



  Future<void> _addToMyProducts() async {
    if (!await _confirmAction(
      AppLocalizations.of(context)!.addProductQuestionTitle,
      AppLocalizations.of(context)!.addProductQuestion(_currentProduct.name),
    )) {
      return;
    }

    await _executeAction(
      action: () => _productService.addProductToHave(_currentProduct),
      successMessage: AppLocalizations.of(context)!.productAddedToList(_currentProduct.name),
      loadingKey: 'adding',
      onSuccess: () {
        if (widget.isFromSearch && mounted) Navigator.pop(context);
      },
    );
  }

  Future<void> _editProduct() async {
    final previousProduct = _currentProduct;
    final editedProduct = await showDialog<BeautyProduct>(
      context: context,
      builder: (context) => EditProductDialog(
        product: _currentProduct,
        onProductUpdated: (updatedProduct) {

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
        successMessage: AppLocalizations.of(context)!.productUpdatedSuccess,
        loadingKey: 'editing',
      );

      if (_hasExpirationInputsChanged(previousProduct, _currentProduct)) {
        await _autoCalculateExpirationIfNeeded();
      }
    }
  }

  Future<void> _deleteProduct() async {
    if (!await _confirmAction(
      AppLocalizations.of(context)!.deleteProductTitle,
      AppLocalizations.of(context)!.deleteProductQuestion(_currentProduct.name),
      isDanger: true,
    )) {
      return;
    }

    _setLoading('deleting', true);
    final deleted = await _productService.deleteProduct(_currentProduct.id!);
    _setLoading('deleting', false);

    if (deleted) {
      await _showMessage(AppLocalizations.of(context)!.productDeletedFromList(_currentProduct.name));
      if (mounted) Navigator.pop(context, true);
    } else {
      await _showMessage(AppLocalizations.of(context)!.deleteProductError, isError: true);
    }
  }

  Future<void> _markAsFinished() async {
  if (!await _confirmAction(
    AppLocalizations.of(context)!.markAsFinishedTitle,
    AppLocalizations.of(context)!.markAsFinishedQuestion(_currentProduct.name),
  )) {
    return;
  }

  await _executeAction(
    action: () => _productService.updateProduct(_currentProduct.id!, {
      'listType': 'used',
      'finishedDate': DateTime.now().toIso8601String(),
    }),
    successMessage: AppLocalizations.of(context)!.productMarkedFinished(_currentProduct.name),
    loadingKey: 'finishing',
  );
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
            Text(AppLocalizations.of(context)!.openProduct, style: theme.textTheme.titleLarge),
          ],
        ),
        contentPadding: const EdgeInsets.only(top: 16, bottom: 8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogListTile(
              icon: Icons.today,
              title: AppLocalizations.of(context)!.today,
              onTap: () => Navigator.pop(context, 'hoy'),
            ),
            _DialogListTile(
              icon: Icons.calendar_month,
              title: AppLocalizations.of(context)!.anotherDate,
              onTap: () => Navigator.pop(context, 'otra'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
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
      successMessage: AppLocalizations.of(context)!.productMarkedOpened,
      loadingKey: 'opening',
    );

    await _autoCalculateExpirationIfNeeded();
  }

  Future<void> _markAsClosed() async {
    await _executeAction(
      action: () => _productService.markAsClosed(_currentProduct.id!),
      successMessage: AppLocalizations.of(context)!.productMarkedClosed,
      loadingKey: 'closing',
    );
  }

  bool _routineContainsProduct(Routine routine, String productId) {
    return routine.products.any((product) => product.productId == productId);
  }

  Future<void> _showAddToRoutineSheet() async {
    final productId = _currentProduct.id;
    if (productId == null) {
      await _showMessage(
        AppLocalizations.of(context)!.errorPerformingOperation,
        isError: true,
      );
      return;
    }

    _setLoading('addingToRoutine', true);
    List<Routine> routines = [];
    try {
      routines = await _routineService.getRoutines();
    } catch (_) {
      _setLoading('addingToRoutine', false);
      await _showMessage(AppLocalizations.of(context)!.routinesLoadError, isError: true);
      return;
    }
    _setLoading('addingToRoutine', false);

    if (!mounted) return;

    String searchQuery = '';
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final theme = Theme.of(ctx);
            final filteredRoutines = routines.where((routine) {
              final query = searchQuery.trim().toLowerCase();
              if (query.isEmpty) return true;
              return routine.name.toLowerCase().contains(query);
            }).toList();

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.65,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.addToRoutine,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: TextField(
                      onChanged: (value) => setModalState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.searchNameBrand,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: routines.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(28),
                              child: Text(
                                AppLocalizations.of(context)!.createFirstRoutineHomeHint,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          )
                        : filteredRoutines.isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.searchNoResults,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            itemCount: filteredRoutines.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, index) {
                              final routine = filteredRoutines[index];
                              final alreadyAdded = _routineContainsProduct(routine, productId);
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: theme.colorScheme.outlineVariant.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  routine.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  routine.type == RoutineType.morning
                                      ? AppLocalizations.of(context)!.morningRoutineLabel
                                      : AppLocalizations.of(context)!.nightRoutineLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Icon(
                                  alreadyAdded ? Icons.check_circle : Icons.add_circle_outline,
                                  color: alreadyAdded
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.primary,
                                ),
                                onTap: () async {
                                  if (alreadyAdded) {
                                    Navigator.pop(sheetContext);
                                    await _showMessage(
                                      AppLocalizations.of(context)!.productAlreadyInRoutine,
                                    );
                                    return;
                                  }

                                  Navigator.pop(sheetContext);
                                  await _addProductToRoutine(routine, productId);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _addProductToRoutine(Routine routine, String productId) async {
    final routineId = routine.id;
    if (routineId == null) {
      await _showMessage(AppLocalizations.of(context)!.productAddError, isError: true);
      return;
    }

    _setLoading('addingToRoutine', true);
    try {
      await _routineService.addProduct(routineId, productId);
      await _showMessage(
        AppLocalizations.of(context)!.productAddedToRoutineNamed(routine.name),
      );
    } catch (_) {
      await _showMessage(AppLocalizations.of(context)!.productAddError, isError: true);
    } finally {
      _setLoading('addingToRoutine', false);
    }
  }

  bool _hasExpirationInputsChanged(
    BeautyProduct previous,
    BeautyProduct current,
  ) {
    final previousOpened = previous.openedDate?.toIso8601String();
    final currentOpened = current.openedDate?.toIso8601String();
    final previousExpiration = previous.expirationDate?.toIso8601String();
    final currentExpiration = current.expirationDate?.toIso8601String();
    final previousPao = (previous.periodAfterOpening ?? '').trim();
    final currentPao = (current.periodAfterOpening ?? '').trim();

    return previousOpened != currentOpened ||
        previousExpiration != currentExpiration ||
        previousPao != currentPao;
  }

  bool _shouldAutoCalculateExpiration(BeautyProduct product) {
    final hasOpenedDate = product.openedDate != null;
    final hasPao = (product.periodAfterOpening ?? '').trim().isNotEmpty;
    final hasManualExpiration = product.expirationDate != null;
    return hasOpenedDate && hasPao && !hasManualExpiration;
  }

  Future<void> _autoCalculateExpirationIfNeeded() async {
    final product = _currentProduct;
    final id = product.id;
    if (id == null || !_shouldAutoCalculateExpiration(product)) return;

    final recalculated = await _productService.calculateExpiration(id);
    if (recalculated != null && mounted) {
      setState(() => _currentProduct = recalculated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProductSaved = _currentProduct.id != null;
    final showAddButton = widget.isFromSearch || !isProductSaved;
    final currentListType = isProductSaved
        ? ProductListType.fromNullable(_currentProduct.listType)
        : null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.primary,
        title: Text(
          'DueGlow',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.crimsonText(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.primary,
          ),
        ),
        actions: [
          if (isProductSaved)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _isLoading('editing') ? null : _editProduct,
              tooltip: AppLocalizations.of(context)!.editProductTooltip,
              color: theme.colorScheme.primary,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
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
              if (_validCategories.isNotEmpty)
                _buildCategories(theme),
              const SizedBox(height: 24),
              _buildScrollableButtons(isProductSaved, showAddButton),
            ],
          ),
        ),
      ),
      bottomNavigationBar: isProductSaved
          ? SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: AppLocalizations.of(context)!.deleteProduct,
                    onPressed: _isLoading('deleting') ? () {} : _deleteProduct,
                    type: ButtonType.danger,
                    size: ButtonSize.full,
                    icon: Icons.delete_outline,
                    isLoading: _isLoading('deleting'),
                    isEnabled: !_isLoading('deleting'),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildProductHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.12),
            theme.colorScheme.primary.withValues(alpha: 0.03),
          ],
        ),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 112,
            height: 112,
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
          const SizedBox(height: 14),
          Text(
            _currentProduct.name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (_currentProduct.brand?.isNotEmpty == true) ...[
            const SizedBox(height: 6),
            Text(
              _currentProduct.brand!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (_currentProduct.rating != null) ...[
            const SizedBox(height: 10),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
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
                Text(
                  '${_currentProduct.rating}/5',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
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
                  AppLocalizations.of(context)!.currentList,
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
            tooltip: AppLocalizations.of(context)!.changeListTooltip,
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ThemeData theme) {
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final isReallyOpened =
        _currentProduct.isOpened == true && _currentProduct.openedDate != null;
    final isExpired = _isCurrentProductExpired();
    final hasExpirationInfo =
        _currentProduct.expirationDate != null ||
        (_currentProduct.periodAfterOpening?.isNotEmpty == true);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isExpired) ...[
            _buildExpiredWarning(theme),
            const SizedBox(height: 12),
          ],
          if (_currentProduct.addedAt != null) ...[
            _InfoRow(
              icon: Icons.calendar_today,
              label: AppLocalizations.of(context)!.addedLabel,
              value: _formatDate(_currentProduct.addedAt!),
            ),
            const SizedBox(height: 12),
          ],
          if (_currentProduct.expirationDate != null) ...[
            _InfoRow(
              icon: Icons.warning_amber,
              label: AppLocalizations.of(context)!.expirationLabel,
              value: _formatDate(_currentProduct.expirationDate!),
            ),
            const SizedBox(height: 12),
          ],
          if (isReallyOpened && _currentProduct.openedDate != null) ...[
            _InfoRow(
              icon: Icons.open_in_new,
              label: AppLocalizations.of(context)!.openedOnLabel,
              value: _formatDate(_currentProduct.openedDate!),
            ),
            const SizedBox(height: 12),
          ],
          if (isReallyOpened &&
              _currentProduct.periodAfterOpening?.isNotEmpty == true) ...[
            _InfoRow(
              icon: Icons.timer,
              label: AppLocalizations.of(context)!.periodAfterOpening,
              value: _currentProduct.periodAfterOpening!,
            ),
            const SizedBox(height: 12),
          ],
          if (isReallyOpened && !hasExpirationInfo)
            _buildExpirationWarning(theme),
          if (_currentProduct.notes?.isNotEmpty == true) ...[
            const Divider(height: 24),
            Text(
              AppLocalizations.of(context)!.notes,
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

  bool _isCurrentProductExpired() {
    final expirationDate = _currentProduct.expirationDate;
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

  Widget _buildExpiredWarning(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 18,
            color: theme.colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context)!.expiredLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
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
                  AppLocalizations.of(context)!.noExpirationInfoWarningTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: warningColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.noExpirationInfoWarningBody,
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
    final categories = _validCategories;
    if (categories.isEmpty) return const SizedBox.shrink();

    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final chipBg = theme.colorScheme.onSurface.withValues(alpha: 0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.categories,
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
          children: categories
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
    final isInFinishedList =
        ProductListType.fromNullable(_currentProduct.listType) ==
        ProductListType.used;

    return Column(
      children: [
        if (showAddButton) ...[
          CustomButton(
            text: AppLocalizations.of(context)!.addToMyProducts,
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
            text: AppLocalizations.of(context)!.openProduct,
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
            text: AppLocalizations.of(context)!.closeProduct,
            onPressed: _isLoading('closing') ? () {} : _markAsClosed,
            type: ButtonType.secondary,
            size: ButtonSize.full,
            icon: Icons.close,
            isLoading: _isLoading('closing'),
            isEnabled: !_isLoading('closing') && !_isLoading('editing'),
          ),
          const SizedBox(height: 12),
        ],
        if (isProductSaved && !isInFinishedList) ...[
          CustomButton(
            text: AppLocalizations.of(context)!.finishedProduct,
            onPressed: _isLoading('finishing') ? () {} : _markAsFinished,
            type: ButtonType.secondary,
            size: ButtonSize.full,
            icon: Icons.check_circle_outline,
            isLoading: _isLoading('finishing'),
            isEnabled: !_isLoading('finishing') && !_isLoading('editing'),
          ),
          const SizedBox(height: 12),
        ],
        if (isProductSaved) ...[
          const SizedBox(height: 24),
          CustomButton(
            text: AppLocalizations.of(context)!.addToRoutine,
            onPressed: _isLoading('addingToRoutine') ? () {} : _showAddToRoutineSheet,
            type: ButtonType.outlined,
            size: ButtonSize.full,
            icon: Icons.playlist_add,
            isLoading: _isLoading('addingToRoutine'),
            isEnabled: !_isLoading('addingToRoutine'),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}



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

