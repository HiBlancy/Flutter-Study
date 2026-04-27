

import 'package:flutter/material.dart';
import 'dart:io';
import '../models/beauty_product.dart';
import '../models/product_list_type.dart';
import '../services/product_service.dart';
import '../services/image_service.dart';
import 'custom_text_field.dart';
import '../l10n/app_localizations.dart';

class EditProductDialog extends StatefulWidget {
  final BeautyProduct product;
  final Function(BeautyProduct) onProductUpdated;

  const EditProductDialog({
    super.key,
    required this.product,
    required this.onProductUpdated,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final ProductService _productService = ProductService();
  final ImageService _imageService = ImageService();

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


  File? _selectedImageFile;
  String? _currentImageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p.name);
    _brandController = TextEditingController(text: p.brand ?? '');
    _notesController = TextEditingController(text: p.notes ?? '');
    _periodAfterOpeningController = TextEditingController(
      text: p.periodAfterOpening ?? '',
    );
    _rating = p.rating;
    _expirationDate = p.expirationDate;
    _openedDate = p.openedDate;
    _categories = List.from(p.categories ?? []);
    _selectedListType = ProductListType.fromNullable(p.listType);
    _currentImageUrl = p.imageUrl;
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
                    AppLocalizations.of(context)!.changeProductImageTitle,
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
                if (_currentImageUrl != null || _selectedImageFile != null)
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(AppLocalizations.of(context)!.deleteImage, style: const TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      _deleteImage();
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
    setState(() => _isUploadingImage = true);

    final imageFile = await _imageService.takePhotoWithCamera();

    if (imageFile != null && mounted) {
      setState(() {
        _selectedImageFile = imageFile;
      });
      _showSnackBar(AppLocalizations.of(context)!.imageCapturedSuccess);
    } else if (mounted) {
      _showSnackBar(AppLocalizations.of(context)!.imageCaptureError, isError: true);
    }

    setState(() => _isUploadingImage = false);
  }


  Future<void> _pickImageFromGallery() async {
    setState(() => _isUploadingImage = true);

    final imageFile = await _imageService.pickImageFromGallery();

    if (imageFile != null && mounted) {
      setState(() {
        _selectedImageFile = imageFile;
      });
      _showSnackBar(AppLocalizations.of(context)!.imageSelectedSuccess);
    } else if (mounted) {
      _showSnackBar(AppLocalizations.of(context)!.imageSelectError, isError: true);
    }

    setState(() => _isUploadingImage = false);
  }


  Future<void> _deleteImage() async {
    setState(() => _isUploadingImage = true);

    try {
      final updatedProduct = await _productService.deleteProductImage(
        widget.product.id!,
      );

      if (updatedProduct != null && mounted) {
        setState(() {
          _currentImageUrl = null;
          _selectedImageFile = null;
        });
        _showSnackBar(AppLocalizations.of(context)!.imageDeletedSuccess);


        widget.onProductUpdated(updatedProduct);
      } else {
        _showSnackBar(AppLocalizations.of(context)!.deleteImageError, isError: true);
      }
    } catch (e) {
      print('❌ Error eliminando imagen: $e');
      _showSnackBar(AppLocalizations.of(context)!.deleteImageError, isError: true);
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
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

  Future<void> _saveProduct() async {
  if (_nameController.text.trim().isEmpty) {
    _showSnackBar(AppLocalizations.of(context)!.nameRequiredError, isError: true);
    return;
  }

  setState(() => _isUploadingImage = true);

  try {

    bool imageUploaded = false;
    if (_selectedImageFile != null) {
      final uploadedProduct = await _productService.uploadProductImage(
        widget.product.id!,
        _selectedImageFile!,
      );
      if (uploadedProduct != null) {
        imageUploaded = true;
        widget.onProductUpdated(uploadedProduct);

        _currentImageUrl = uploadedProduct.imageUrl;

      } else {
        _showSnackBar(AppLocalizations.of(context)!.imageUploadError, isError: true);
        return;
      }
    }




    final updatedProductData = {
      'name': _nameController.text.trim(),
      'brand': _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
      'categories': _categories.isEmpty ? null : _categories,
      'notes': _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      'rating': _rating,
      'listType': _selectedListType.value,
      'expirationDate': _expirationDate?.toIso8601String(),
      'periodAfterOpening': _periodAfterOpeningController.text.trim().isEmpty ? null : _periodAfterOpeningController.text.trim(),
      'openedDate': _openedDate?.toIso8601String(),
    };







    final result = await _productService.updateProduct(
      widget.product.id!,
      updatedProductData,
    );

    if (result != null && mounted) {


      final finalProduct = imageUploaded && _currentImageUrl != null
          ? result.copyWith(imageUrl: _currentImageUrl)
          : result;
      widget.onProductUpdated(finalProduct);
      Navigator.pop(context, finalProduct);
      _showSnackBar(AppLocalizations.of(context)!.productUpdatedSuccess);
    } else {
      _showSnackBar(AppLocalizations.of(context)!.saveChangesError, isError: true);
    }
  } catch (e) {
    print('❌ Error guardando producto: $e');
    _showSnackBar(AppLocalizations.of(context)!.saveChangesError, isError: true);
  } finally {
    if (mounted) setState(() => _isUploadingImage = false);
  }
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

                    _buildImageSelector(theme, subtleBorder),
                    const SizedBox(height: 20),


                    _buildListSelector(theme, subtleBorder),
                    const SizedBox(height: 20),


                    CustomTextField(
                      controller: _nameController,
                      label: AppLocalizations.of(context)!.productNameRequiredLabel,
                      prefixIcon: Icons.spa,
                      hint: AppLocalizations.of(context)!.productNameHint,
                    ),
                    const SizedBox(height: 16),


                    CustomTextField(
                      controller: _brandController,
                      label: AppLocalizations.of(context)!.brand,
                      prefixIcon: Icons.branding_watermark,
                      hint: AppLocalizations.of(context)!.brandHint,
                    ),
                    const SizedBox(height: 16),


                    _buildRatingSection(subtleBorder),
                    const SizedBox(height: 16),


                    _buildDateSelector(
                      icon: Icons.warning_amber,
                      iconColor: Colors.orange,
                      text: _expirationDate != null
                          ? AppLocalizations.of(context)!.expirationWithDate(_formatDate(_expirationDate!))
                          : AppLocalizations.of(context)!.addExpirationDate,
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
                      controller: _periodAfterOpeningController,
                      label: AppLocalizations.of(context)!.periodAfterOpening,
                      prefixIcon: Icons.timer,
                      hint: AppLocalizations.of(context)!.customPaoHint,
                    ),
                    const SizedBox(height: 16),


                    _buildCategoriesSection(subtleBorder),
                    const SizedBox(height: 16),


                    CustomTextField(
                      controller: _notesController,
                      label: AppLocalizations.of(context)!.additionalNotes,
                      prefixIcon: Icons.note,
                      hint: AppLocalizations.of(context)!.notes,
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


  Widget _buildImageSelector(ThemeData theme, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.productImage,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _isUploadingImage ? null : _showImagePickerOptions,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: _isUploadingImage
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.uploadingImage,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  : (_selectedImageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 120,
                          ),
                        )
                      : (_currentImageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _currentImageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 120,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder(theme);
                                },
                              ),
                            )
                          : _buildImagePlaceholder(theme))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 40,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.tapToAddImage,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? theme.colorScheme.surface : theme.colorScheme.primary;
    final fgColor = isDark ? const Color(0xfff4add8) : theme.colorScheme.onPrimary;

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
            AppLocalizations.of(context)!.editProduct,
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
            AppLocalizations.of(context)!.list,
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
                AppLocalizations.of(context)!.rating,
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
                    AppLocalizations.of(context)!.clear,
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
                tooltip: AppLocalizations.of(context)!.deleteDateTooltip,
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
                AppLocalizations.of(context)!.categories,
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
                    AppLocalizations.of(context)!.deleteAll,
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
                  hint: AppLocalizations.of(context)!.newCategory,
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
  final theme = Theme.of(context);

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: borderColor)),
    ),
    child: Row(
      children: [

        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: ElevatedButton(
            onPressed: _isUploadingImage
                ? null
                : () {
                    _saveProduct();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isUploadingImage
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(AppLocalizations.of(context)!.save),
          ),
        ),
      ],
    ),
  );
}

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}