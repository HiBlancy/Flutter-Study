
import 'dart:io';
import 'package:dueglow/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../models/beauty_product.dart';
import '../services/product_service.dart';
import '../services/image_service.dart';
import '../widgets/main_toolbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../l10n/app_localizations.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  final ImageService _imageService = ImageService();

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


  File? _selectedImageFile;
  bool _isUploadingImage = false;


  final List<String> _paoOptions = ['3M', '6M', '12M', '18M', '24M'];

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


  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    AppLocalizations.of(context)!.addProductImageTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(AppLocalizations.of(context)!.takePhoto),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(AppLocalizations.of(context)!.chooseFromGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImageFromGallery();
                  },
                ),
                if (_selectedImageFile != null)
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(AppLocalizations.of(context)!.deleteImage, style: const TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _selectedImageFile = null);
                      _showSnackBar(AppLocalizations.of(context)!.imageDeleted);
                    },
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> _pickImageFromCamera() async {
    final imageFile = await _imageService.takePhotoWithCamera();

    if (imageFile != null && mounted) {
      setState(() {
        _selectedImageFile = imageFile;
      });
      _showSnackBar(AppLocalizations.of(context)!.imageCapturedSuccess);
    } else if (mounted) {
      _showSnackBar(AppLocalizations.of(context)!.imageCaptureError, isError: true);
    }
  }


  Future<void> _pickImageFromGallery() async {
    final imageFile = await _imageService.pickImageFromGallery();

    if (imageFile != null && mounted) {
      setState(() {
        _selectedImageFile = imageFile;
      });
      _showSnackBar(AppLocalizations.of(context)!.imageSelectedSuccess);
    } else if (mounted) {
      _showSnackBar(AppLocalizations.of(context)!.imageSelectError, isError: true);
    }
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


  void _selectPao(String pao) {
    setState(() {
      _paoController.text = pao;
    });
  }

  Future<void> _saveProductManually() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newProduct = BeautyProduct(
        barcode: _barcodeController.text.trim(),
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

      var addedProduct = await _productService.addProductToHave(newProduct);

      if (addedProduct != null && mounted) {
        if (_selectedImageFile != null) {
          setState(() => _isUploadingImage = true);

          final updatedProduct = await _productService.uploadProductImage(
            addedProduct.id!,
            _selectedImageFile!,
          );

          setState(() => _isUploadingImage = false);

          if (updatedProduct != null) {
            addedProduct = updatedProduct;
          } else {
            _showSnackBar(AppLocalizations.of(context)!.productSavedImageUploadFailed, isError: true);
          }
        }

        if (mounted) {
          setState(() => _isLoading = false);
          _showSnackBar(AppLocalizations.of(context)!.productAddedSuccess);
          _clearForm();
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          _showSnackBar(AppLocalizations.of(context)!.saveProductError, isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar(AppLocalizations.of(context)!.saveProductError, isError: true);
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
      _selectedImageFile = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBackgroundColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.15);

    return CustomAppBar(
      title: AppLocalizations.of(context)!.addProductTitle,
      showDrawer: true,
      showBackButton: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.qr_code_scanner,
                    title: AppLocalizations.of(context)!.scanAction,
                    subtitle: AppLocalizations.of(context)!.barcodeSubtitle,
                    color: cardBackgroundColor,
                    onTap: () => Navigator.pushNamed(context, AppConstants.routeScan),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.search,
                    title: AppLocalizations.of(context)!.searchAction,
                    subtitle: AppLocalizations.of(context)!.onlineProductSubtitle,
                    color: cardBackgroundColor,
                    onTap: () => Navigator.pushNamed(context, '/search'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),


            Row(
              children: [
                Expanded(child: Divider(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.orAddManuallyUpper,
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Expanded(child: Divider(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
              ],
            ),
            const SizedBox(height: 28),


            Form(
              key: _formKey,
              child: Column(
                children: [

                  _buildImageSelector(theme, cardBackgroundColor),
                  const SizedBox(height: 24),

                  CustomTextField(
                    controller: _nameController,
                    label: AppLocalizations.of(context)!.productNameRequiredLabel,
                    prefixIcon: Icons.spa_outlined,
                    hint: AppLocalizations.of(context)!.productNameHint,
                    validator: (v) => v?.trim().isEmpty == true ? AppLocalizations.of(context)!.requiredField : null,
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: _brandController,
                    label: AppLocalizations.of(context)!.brand,
                    prefixIcon: Icons.branding_watermark_outlined,
                    hint: AppLocalizations.of(context)!.brandHint,
                  ),
                  const SizedBox(height: 20),


                  _buildDateSelector(
                    icon: Icons.calendar_today_outlined,
                    text: _expirationDate != null
                        ? AppLocalizations.of(context)!.expiresLabel(_formatDate(_expirationDate!))
                        : AppLocalizations.of(context)!.expirationDate,
                    isActive: _expirationDate != null,
                    onTap: () => _selectDate(
                      initialDate: _expirationDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                      onDateSelected: (date) => setState(() => _expirationDate = date),
                    ),
                    onClear: () => setState(() => _expirationDate = null),
                  ),
                  const SizedBox(height: 20),


                  _buildPaoSelector(theme),
                  const SizedBox(height: 20),


                  _buildCategoriesSection(theme),
                  const SizedBox(height: 24),


                  CustomButton(
                    text: AppLocalizations.of(context)!.saveInMyVanity,
                    onPressed: _saveProductManually,
                    isLoading: _isLoading || _isUploadingImage,
                    type: ButtonType.primary,
                    size: ButtonSize.full,
                    icon: Icons.add_task_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }


  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 28,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildImageSelector(ThemeData theme, Color cardBackgroundColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image_outlined, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.productImage,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _isUploadingImage ? null : _showImagePickerOptions,
            child: Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: _selectedImageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _selectedImageFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 130,
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 42,
                            color: theme.colorScheme.primary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.tapToAddImage,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPaoSelector(ThemeData theme) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.timer_outlined, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.paoDuration,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [

              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.auto_awesome_outlined,
                          size: 28,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PAO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.periodAfterOpening,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.findOpenJarIcon,
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: _paoOptions.map((pao) {
                  final isSelected = _paoController.text.trim() == pao;
                  return GestureDetector(
                    onTap: () => _selectPao(pao),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            pao,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),
              TextField(
                controller: _paoController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.customPaoHint,
                  hintStyle: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector({
    required IconData icon,
    required String text,
    required bool isActive,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: TextStyle(color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.outline))),
            if (isActive)
              IconButton(
                icon: Icon(Icons.clear, size: 18, color: theme.colorScheme.error),
                onPressed: onClear,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            Icon(Icons.edit_calendar_outlined, size: 18, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _newCategoryController,
                label: AppLocalizations.of(context)!.category,
                prefixIcon: Icons.category_outlined,
                hint: AppLocalizations.of(context)!.categoryHint,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _addCategory,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        if (_categories.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) => Chip(
              label: Text(cat, style: const TextStyle(fontSize: 12)),
              onDeleted: () => setState(() => _categories.remove(cat)),
              backgroundColor: theme.colorScheme.surface,
              side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
              deleteIconColor: theme.colorScheme.error,
            )).toList(),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}