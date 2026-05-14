import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image/image.dart' as img;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          final tempDir = Directory.systemTemp;
          final file = File('${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await file.writeAsBytes(bytes);
          return _normalizeImageOrientation(file);
        } else {
          return _normalizeImageOrientation(File(pickedFile.path));
        }
      }
      return null;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  Future<File?> takePhotoWithCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          final tempDir = Directory.systemTemp;
          final file = File('${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');
          await file.writeAsBytes(bytes);
          return _normalizeImageOrientation(file);
        } else {
          return _normalizeImageOrientation(File(pickedFile.path));
        }
      }
      return null;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> getImageInfo(File imageFile) async {
    try {
      final size = await imageFile.length();
      return {
        'size': size,
        'sizeInMB': (size / 1024 / 1024).toStringAsFixed(2),
        'isWeb': kIsWeb,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<File> _normalizeImageOrientation(File imageFile) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      final img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return imageFile;

      final img.Image oriented = img.bakeOrientation(decoded);
      final List<int> encoded = img.encodeJpg(oriented, quality: 85);
      await imageFile.writeAsBytes(encoded, flush: true);
      return imageFile;
    } catch (e) {
      print('⚠️ Could not normalize image orientation: $e');
      return imageFile;
    }
  }
}