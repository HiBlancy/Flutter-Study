import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
import '../constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Acerca de',
      showDrawer: true,
      showBackButton: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.soap, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                AppConstants.appName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Versión 1.0.0',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                'Aplicación para el cuidado de la piel',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}