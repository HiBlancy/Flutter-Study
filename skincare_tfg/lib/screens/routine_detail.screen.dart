
import 'package:flutter/material.dart';
import '../models/routine_model.dart';
import '../models/beauty_product.dart';
import '../services/routine_service.dart';
import '../services/product_service.dart';
import '../widgets/main_toolbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../l10n/app_localizations.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Routine routine;

  const RoutineDetailScreen({super.key, required this.routine});

  @override
  State<RoutineDetailScreen> createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  final RoutineService _routineService = RoutineService();
  final ProductService _productService = ProductService();

  late Routine _routine;
  bool _isLoading = false;
  bool _hasChanges = false;

  bool _isEditing = false;
  late TextEditingController _nameController;
  RoutineType _editingType = RoutineType.morning;
  Set<String> _editingDays = {};

  final List<Map<String, String>> _allDays = [
    {'key': 'monday', 'short': 'L', 'long': 'Lunes'},
    {'key': 'tuesday', 'short': 'M', 'long': 'Martes'},
    {'key': 'wednesday', 'short': 'X', 'long': 'Miércoles'},
    {'key': 'thursday', 'short': 'J', 'long': 'Jueves'},
    {'key': 'friday', 'short': 'V', 'long': 'Viernes'},
    {'key': 'saturday', 'short': 'S', 'long': 'Sábado'},
    {'key': 'sunday', 'short': 'D', 'long': 'Domingo'},
  ];

  @override
  void initState() {
    super.initState();
    _routine = widget.routine;
    _nameController = TextEditingController(text: _routine.name);
    _editingType = _routine.type;
    _editingDays = _routine.days.toSet();
    _loadFreshRoutine();
  }

  Future<void> _loadFreshRoutine() async {
    if (_routine.id == null) return;
    try {
      final freshRoutine = await _routineService.getRoutineById(_routine.id!);
      if (mounted && freshRoutine != null) {
        setState(() {
          _routine = freshRoutine;
          _nameController.text = freshRoutine.name;
          _editingType = freshRoutine.type;
          _editingDays = freshRoutine.days.toSet();
        });
      }
    } catch (e) {
      print('Error loading fresh routine: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveRoutineInfo() async {
    if (_routine.id == null) return;
    setState(() => _isLoading = true);
    try {
      final sortedDays = _editingDays.toList()..sort();

      setState(() {
        _routine = _routine.copyWith(type: _editingType, days: sortedDays);
      });
      final updated = await _routineService.updateRoutine(_routine.id!, {
        'name': _nameController.text.trim(),
        'type': _editingType == RoutineType.morning ? 'morning' : 'night',
        'days': sortedDays,
      });
      setState(() {
        _routine = updated;
        _hasChanges = true;
        _isEditing = false;
      });
      _showSnackBar(AppLocalizations.of(context)!.routineUpdated);
    } catch (e) {
      _showSnackBar(AppLocalizations.of(context)!.updateError, isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeProduct(RoutineProduct product) async {
    if (_routine.id == null) return;
    setState(() => _isLoading = true);
    try {
      final updated = await _routineService.removeProduct(
        _routine.id!,
        product.productId,
      );
      setState(() {
        _routine = updated;
        _hasChanges = true;
      });
      _showSnackBar(AppLocalizations.of(context)!.productRemovedFromRoutine);
    } catch (e) {
      _showSnackBar(AppLocalizations.of(context)!.productRemoveError, isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (_routine.id == null) return;

    final products = List<RoutineProduct>.from(_routine.products);
    if (newIndex > oldIndex) newIndex--;
    final item = products.removeAt(oldIndex);
    products.insert(newIndex, item);


    setState(() {
      _routine = _routine.copyWith(products: products);
    });


    final reorderPayload = products
        .asMap()
        .entries
        .map((e) => {'productId': e.value.productId, 'order': e.key})
        .toList();

    try {
      final updated = await _routineService.reorderProducts(
        _routine.id!,
        reorderPayload,
      );
      setState(() {
        _routine = updated;
        _hasChanges = true;
      });
    } catch (e) {

      setState(() => _routine = widget.routine);
      _showSnackBar(AppLocalizations.of(context)!.reorderProductsError, isError: true);
    }
  }

  void _showAddProductSheet() async {
    if (_routine.id == null) return;

    List<BeautyProduct> userProducts = [];
    bool loadingProducts = true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {

            if (loadingProducts) {
              _productService
                  .getProducts(listType: 'have', limit: 100)
                  .then((paginated) {
                    if (ctx.mounted) {
                      setModalState(() {
                        userProducts = paginated?.products ?? [];
                        loadingProducts = false;
                      });
                    }
                  })
                  .catchError((_) {
                    if (ctx.mounted)
                      setModalState(() => loadingProducts = false);
                  });
            }

            final theme = Theme.of(ctx);
            final isDark = theme.brightness == Brightness.dark;

            final addedIds = _routine.products.map((p) => p.productId).toSet();
            final available = userProducts
                .where((p) => !addedIds.contains(p.id))
                .toList();

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.7,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
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
                          AppLocalizations.of(context)!.addProduct,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: loadingProducts
                        ? const Center(child: CircularProgressIndicator())
                        : available.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 48,
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppLocalizations.of(context)!.noMoreProductsToAdd,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            itemCount: available.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final product = available[i];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: theme.colorScheme.outlineVariant
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                leading: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? theme.colorScheme.primaryContainer
                                              .withValues(alpha: 0.2)
                                        : theme.colorScheme.primaryContainer
                                              .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: product.imageUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            product.imageUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.face_retouching_natural,
                                          size: 22,
                                          color: theme.colorScheme.primary
                                              .withValues(alpha: 0.5),
                                        ),
                                ),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: product.brand != null
                                    ? Text(
                                        product.brand!,
                                        style: TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                                trailing: Icon(
                                  Icons.add_circle_outline,
                                  color: theme.colorScheme.primary,
                                ),
                                onTap: () async {
                                  Navigator.pop(sheetCtx);
                                  await _addProduct(product.id!);
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

  Future<void> _addProduct(String productId) async {
    if (_routine.id == null) return;
    setState(() => _isLoading = true);
    try {
      final updated = await _routineService.addProduct(_routine.id!, productId);
      setState(() {
        _routine = updated;
        _hasChanges = true;
      });
      _showSnackBar(AppLocalizations.of(context)!.productAddedToRoutine);
    } catch (e) {
      _showSnackBar(AppLocalizations.of(context)!.productAddError, isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? theme.colorScheme.error : theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMorning = _routine.type == RoutineType.morning;
    final cardBg = theme.colorScheme.primaryContainer.withValues(alpha: isDark ? 0.15 : 0.2);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _hasChanges);
      },
      child: CustomAppBar(
        title: _routine.name,
        showDrawer: false,
        showBackButton: true,
        onBack: () => Navigator.pop(context, _hasChanges),
        child: _isLoading && _routine.products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [


                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Expanded(
                                child: _isEditing
                                    ? CustomTextField(
                                        controller: _nameController,
                                        label: AppLocalizations.of(context)!.routineNameLabel,
                                        prefixIcon: Icons
                                            .edit_outlined,
                                        validator: (v) => v?.isEmpty == true
                                            ? AppLocalizations.of(context)!.requiredField
                                            : null,
                                      )
                                    : Text(
                                        _routine.name,
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isEditing
                                      ? Icons.close
                                      : Icons.edit_outlined,
                                ),
                                onPressed: () {
                                  if (_isEditing) {

                                    setState(() {
                                      _isEditing = false;
                                      _nameController.text = _routine.name;
                                      _editingType = _routine.type;
                                      _editingDays = _routine.days.toSet();
                                    });
                                  } else {
                                    setState(() => _isEditing = true);
                                  }
                                },
                              ),
                              if (_isEditing)
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  onPressed: _saveRoutineInfo,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),


                          if (!_isEditing) ...[

                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isMorning
                                            ? Icons.wb_sunny_outlined
                                            : Icons.nights_stay_outlined,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isMorning
                                            ? 'Rutina de mañana'
                                            : 'Rutina de noche',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _allDays.map((day) {
                                final isActive = _routine.days.contains(
                                  day['key'],
                                );
                                return Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? theme.colorScheme.primary
                                        : (isDark
                                              ? theme
                                                    .colorScheme
                                                    .primaryContainer
                                                    .withValues(alpha: 0.15)
                                              : theme
                                                    .colorScheme
                                                    .primaryContainer
                                                    .withValues(alpha: 0.2)),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    day['short']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? theme.colorScheme.onPrimary
                                          : theme.colorScheme.onSurface
                                                .withValues(alpha: 0.35),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ] else ...[

                            _buildSectionLabel(
                              theme,
                              Icons.schedule_outlined,
                              AppLocalizations.of(context)!.routineType,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTypeCardEditable(
                                    label: AppLocalizations.of(context)!.morning,
                                    icon: Icons.wb_sunny_outlined,
                                    type: RoutineType.morning,
                                    isSelected:
                                        _editingType == RoutineType.morning,
                                    onTap: () => setState(
                                      () => _editingType = RoutineType.morning,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: _buildTypeCardEditable(
                                    label: AppLocalizations.of(context)!.night,
                                    icon: Icons.nights_stay_outlined,
                                    type: RoutineType.night,
                                    isSelected:
                                        _editingType == RoutineType.night,
                                    onTap: () => setState(
                                      () => _editingType = RoutineType.night,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 18,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.weekDays,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_editingDays.length ==
                                          _allDays.length) {
                                        _editingDays.clear();
                                      } else {
                                        _editingDays.addAll(
                                          _allDays.map((d) => d['key']!),
                                        );
                                      }
                                    });
                                  },
                                  child: Text(
                                    _editingDays.length == _allDays.length
                                        ? AppLocalizations.of(context)!.none
                                        : AppLocalizations.of(context)!.all,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: _allDays.map((day) {
                                  final key = day['key']!;
                                  final short = day['short']!;
                                  final isSelected = _editingDays.contains(key);

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _editingDays.remove(key);
                                        } else {
                                          _editingDays.add(key);
                                        }
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 38,
                                      height: 38,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.surface,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.outlineVariant
                                                    .withValues(alpha: 0.5),
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Text(
                                        short,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected
                                              ? theme.colorScheme.onPrimary
                                              : theme.colorScheme.onSurface
                                                    .withValues(alpha: 0.4),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.products,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _routine.products.isEmpty
                                        ? AppLocalizations.of(context)!.noProductAdded
                                        : AppLocalizations.of(context)!.longPressReorder,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              CustomButton(
                                text: AppLocalizations.of(context)!.addProduct,
                                onPressed: _showAddProductSheet,
                                type: ButtonType.outlined,
                                size: ButtonSize.small,
                                icon: Icons.add,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),


                  _routine.products.isEmpty
                      ? SliverToBoxAdapter(
                          child: _buildEmptyProducts(theme, isDark),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          sliver: SliverToBoxAdapter(
                            child: ReorderableListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _routine.products.length,
                              onReorder: _onReorder,
                              proxyDecorator: (child, index, animation) {
                                return Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.transparent,
                                  child: child,
                                );
                              },
                              itemBuilder: (_, i) {
                                final p = _routine.products[i];
                                return _buildProductTile(p, i, theme, isDark);
                              },
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyProducts(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.face_retouching_natural,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noProductsYet,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.addProductsToBuildRoutine,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: AppLocalizations.of(context)!.addProduct,
              onPressed: _showAddProductSheet,
              type: ButtonType.primary,
              size: ButtonSize.medium,
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(
    RoutineProduct p,
    int index,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      key: ValueKey(p.productId),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.12)
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),

            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHigh
                    : theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: p.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(p.imageUrl!, fit: BoxFit.cover),
                    )
                  : Icon(
                      Icons.face_retouching_natural,
                      size: 22,
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
            ),
          ],
        ),
        title: Text(
          p.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: p.brand.isNotEmpty
            ? Text(
                p.brand,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: theme.colorScheme.error.withValues(alpha: 0.7),
                size: 20,
              ),
              onPressed: () => _removeProduct(p),
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),

            Icon(
              Icons.drag_handle_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCardEditable({
    required String label,
    required IconData icon,
    required RoutineType type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : (isDark
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15)
                    : theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.2,
                      )),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

