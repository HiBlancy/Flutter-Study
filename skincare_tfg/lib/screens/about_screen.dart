import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
import '../constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

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
              // Icono principal con el estilo de tu marca
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.spa, // Encaja perfecto con Skincare
                  size: 80, 
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Título de la App (DueGlow)
              Text(
                AppConstants.appName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              
              // Versión
              Text(
                'Versión 1.0.0',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: subtleText,
                ),
              ),
              const SizedBox(height: 32),
              
              // Descripción
              Text(
                'Aplicación para el cuidado de la piel y \nseguimiento de tus rutinas de belleza.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Footer / Copyright
              Text(
                '© ${DateTime.now().year} ${AppConstants.appName}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: subtleText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}