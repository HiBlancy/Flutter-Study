import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Cámara',
      showDrawer: true,
      showBackButton: false,
      child: const Center(
        child: Text(
          'Pantalla de cámara',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}