// custom_button.dart
import 'package:flutter/material.dart';

/// Tipos de botones disponibles
enum ButtonType {
  primary,   // Botón principal (fondo sólido)
  secondary, // Botón secundario (borde, sin fondo)
  danger,    // Botón de peligro (rojo)
  text,      // Botón de texto (sin bordes)
  outlined,  // Botón con borde (similar a secondary pero más genérico)
}

/// Tamaños de botón predefinidos
enum ButtonSize {
  small,   // Compacto
  medium,  // Tamaño estándar
  large,   // Grande
  full,    // Ancho completo
}

class CustomButton extends StatelessWidget {
  // Propiedades requeridas
  final String text;
  final VoidCallback onPressed;
  
  // Propiedades de estilo
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  
  // Propiedades de color personalizado
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? loadingColor;
  
  // Callbacks adicionales
  final VoidCallback? onLongPress;
  
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 12,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.loadingColor,
    this.onLongPress,
  });

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small: return 12;
      case ButtonSize.medium: return 16;
      case ButtonSize.large: return 18;
      case ButtonSize.full: return 18;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(vertical: 8, horizontal: 12);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(vertical: 12, horizontal: 20);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(vertical: 16, horizontal: 24);
      case ButtonSize.full:
        return const EdgeInsets.symmetric(vertical: 16);
    }
  }

  double? _getWidth() {
    if (width != null) return width;
    
    switch (size) {
      case ButtonSize.small: return 100;
      case ButtonSize.medium: return 150;
      case ButtonSize.large: return 200;
      case ButtonSize.full: return double.infinity;
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    
    // Colores por defecto según el tipo
    Color defaultBgColor;
    Color defaultTextColor;
    Color defaultBorderColor;
    
    switch (type) {
      case ButtonType.primary:
        defaultBgColor = backgroundColor ?? theme.colorScheme.primary;
        defaultTextColor = textColor ?? theme.colorScheme.onPrimary;
        defaultBorderColor = borderColor ?? Colors.transparent;
        break;
      case ButtonType.secondary:
      case ButtonType.outlined:
        defaultBgColor = backgroundColor ?? Colors.transparent;
        defaultTextColor = textColor ?? theme.colorScheme.primary;
        defaultBorderColor = borderColor ?? theme.colorScheme.primary;
        break;
      case ButtonType.danger:
        defaultBgColor = backgroundColor ?? theme.colorScheme.error;
        defaultTextColor = textColor ?? theme.colorScheme.onError;
        defaultBorderColor = borderColor ?? Colors.transparent;
        break;
      case ButtonType.text:
        defaultBgColor = backgroundColor ?? Colors.transparent;
        defaultTextColor = textColor ?? theme.colorScheme.primary;
        defaultBorderColor = borderColor ?? Colors.transparent;
        break;
    }
    
    // Ajustar opacidad si está deshabilitado para que se vea bien en cualquier fondo
    final bgColor = isEnabled ? defaultBgColor : defaultBgColor.withValues(alpha: 0.3);
    final txtColor = isEnabled ? defaultTextColor : defaultTextColor.withValues(alpha: 0.5);
    final brdColor = isEnabled ? defaultBorderColor : defaultBorderColor.withValues(alpha: 0.3);
    
    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: txtColor,
      disabledBackgroundColor: bgColor,
      disabledForegroundColor: txtColor,
      elevation: type == ButtonType.text ? 0 : 2,
      shadowColor: type == ButtonType.text ? Colors.transparent : null,
      padding: padding ?? _getDefaultPadding(),
      minimumSize: Size(_getWidth() ?? 0, height ?? 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: (type == ButtonType.secondary || type == ButtonType.outlined)
            ? BorderSide(color: brdColor, width: 1.5)
            : BorderSide.none,
      ),
      textStyle: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: (isEnabled && !isLoading) ? onPressed : null,
      onLongPress: onLongPress,
      style: _getButtonStyle(context),
      child: _buildChild(context), // Pasamos el context para acceder al tema
    );
    
    if (size == ButtonSize.full || width == double.infinity) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    
    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      final theme = Theme.of(context);
      
      // ✅ Calculamos el color del loader dinámicamente según el tipo de botón
      Color defaultLoaderColor;
      if (type == ButtonType.primary) {
        defaultLoaderColor = theme.colorScheme.onPrimary;
      } else if (type == ButtonType.danger) {
        defaultLoaderColor = theme.colorScheme.onError;
      } else {
        defaultLoaderColor = theme.colorScheme.primary; // Para secondary, text, etc.
      }

      return SizedBox(
        height: _getFontSize() + 4,
        width: _getFontSize() + 4,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            loadingColor ?? defaultLoaderColor,
          ),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _getFontSize() + 4),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    
    return Text(text);
  }
}

// Extensión para facilitar el uso con context
extension CustomButtonExtension on BuildContext {
  Widget primaryButton(String text, VoidCallback onPressed, {
    IconData? icon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      size: size,
      icon: icon,
      isLoading: isLoading,
    );
  }
  
  Widget secondaryButton(String text, VoidCallback onPressed, {
    IconData? icon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      size: size,
      icon: icon,
      isLoading: isLoading,
    );
  }
  
  Widget dangerButton(String text, VoidCallback onPressed, {
    IconData? icon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.danger,
      size: size,
      icon: icon,
      isLoading: isLoading,
    );
  }
  
  Widget textButton(String text, VoidCallback onPressed, {
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.text,
      size: size,
      icon: icon,
    );
  }
}