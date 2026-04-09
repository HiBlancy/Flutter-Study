// custom_text_field.dart (adaptado)
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final VoidCallback? onToggleVisibility;
  final bool showVisibilityToggle;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onToggleVisibility,
    this.showVisibilityToggle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Usamos el color 'onSurface' (el color del texto principal) pero con opacidad
    // para crear los iconos y labels. Esto asegura que se vea bien en ambos modos
    // sin tener que usar isDarkMode constantemente.
    final subtleColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      style: theme.textTheme.bodyMedium, // Usar tipografía del tema
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodySmall?.copyWith(color: subtleColor),
        hintText: hint,
        hintStyle: theme.textTheme.bodySmall?.copyWith(color: subtleColor.withValues(alpha: 0.4)),
        
        prefixIcon: Icon(
          prefixIcon,
          color: subtleColor,
        ),
        
        suffixIcon: showVisibilityToggle
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: subtleColor,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
            
        // NOTA: He eliminado las declaraciones de bordes y colores de fondo aquí.
        // ¿Por qué? Porque al usar Material Design, el InputDecorationTheme que
        // configuramos arriba en themes.dart se aplicará automáticamente a todos
        // tus text fields, manteniendo tu código mucho más limpio.
      ),
    );
  }
}