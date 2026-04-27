import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/beauty_product.dart';
import '../services/beauty_api_service.dart';
import '../widgets/main_toolbar.dart';
import 'product_screen.dart';
import '../l10n/app_localizations.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isNavigating = false;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isNavigating) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() => _isNavigating = true);
    _cameraController.stop();

    final product = await BeautyApiService.getProductByBarcode(barcode.rawValue!);

    if (!mounted) return;

    if (product != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductScreen(
            product: product,
            isFromSearch: true,
          ),
        ),
      ).then((_) {
        setState(() => _isNavigating = false);
        _cameraController.start();
      });
    } else {

      final shouldCreate = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          final theme = Theme.of(dialogContext);

          return AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: theme.brightness == Brightness.dark
                  ? BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1))
                  : BorderSide.none,
            ),
            title: Text(AppLocalizations.of(context)!.scanProductNotFound, style: theme.textTheme.titleLarge),
            content: Text(
              AppLocalizations.of(context)!.scanNoBarcodeInfo(barcode.rawValue!),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7)
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.createProduct),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      if (shouldCreate == true) {
        final newProduct = BeautyProduct(
          barcode: barcode.rawValue!,
          name: AppLocalizations.of(context)!.newProductDefaultName,
          brand: '',
          addedAt: DateTime.now(),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductScreen(
              product: newProduct,
              isFromSearch: true,
            ),
          ),
        ).then((_) {
          setState(() => _isNavigating = false);
          _cameraController.start();
        });
      } else {
        setState(() => _isNavigating = false);
        _cameraController.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: AppLocalizations.of(context)!.camera,
      showDrawer: true,
      showBackButton: false,
      child: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,
            onDetect: _onBarcodeDetected,
          ),

          Center(
            child: Container(
              width: 260,
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Stack(
                children: [
                  _Corner(Alignment.topLeft),
                  _Corner(Alignment.topRight),
                  _Corner(Alignment.bottomLeft),
                  _Corner(Alignment.bottomRight),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Text(
              AppLocalizations.of(context)!.aimBarcode,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
              ),
            ),
          ),

          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.flashlight_on, color: Colors.white, size: 28),
              onPressed: () => _cameraController.toggleTorch(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final Alignment alignment;
  const _Corner(this.alignment);

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    final isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;

    final brandColor = Theme.of(context).colorScheme.primary;

    return Align(
      alignment: alignment,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? BorderSide(color: brandColor, width: 4) : BorderSide.none,
            bottom: !isTop ? BorderSide(color: brandColor, width: 4) : BorderSide.none,
            left: isLeft ? BorderSide(color: brandColor, width: 4) : BorderSide.none,
            right: !isLeft ? BorderSide(color: brandColor, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}