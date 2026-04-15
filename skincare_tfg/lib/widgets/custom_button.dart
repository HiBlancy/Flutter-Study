// custom_button.dart
import 'package:flutter/material.dart';

/// Tipos de botones disponibles
enum ButtonType {
  primary, // Botón principal (fondo sólido)
  secondary, // Botón secundario (borde, sin fondo)
  danger, // Botón de peligro (rojo)
  text, // Botón de texto (sin bordes)
  outlined, // Botón con borde (similar a secondary pero más genérico)
}

/// Tamaños de botón predefinidos
enum ButtonSize {
  small, // Compacto
  medium, // Tamaño estándar
  large, // Grande
  full, // Ancho completo
}

class CustomButton extends StatefulWidget {
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

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  double _getFontSize() {
    switch (widget.size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
      case ButtonSize.full:
        return 18;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (widget.size) {
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
    if (widget.width != null) return widget.width;

    switch (widget.size) {
      case ButtonSize.small:
        return 100;
      case ButtonSize.medium:
        return 150;
      case ButtonSize.large:
        return 200;
      case ButtonSize.full:
        return double.infinity;
    }
  }

  void _handlePress() {
    if (widget.isEnabled && !widget.isLoading) {
      _scaleController.forward().then((_) {
        _scaleController.reverse();
      });
      widget.onPressed();
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colores por defecto según el tipo
    Color defaultBgColor;
    Color defaultTextColor;
    Color defaultBorderColor;
    Color? defaultHoverColor;

    double _getDefaultHeight() {
      switch (widget.size) {
        case ButtonSize.small:
          return 36;
        case ButtonSize.medium:
          return 48;
        case ButtonSize.large:
          return 56;
        case ButtonSize.full:
          return 56;
      }
    }

    switch (widget.type) {
      case ButtonType.primary:
        defaultBgColor = widget.backgroundColor ?? theme.colorScheme.primary;
        defaultTextColor = widget.textColor ?? theme.colorScheme.onPrimary;
        defaultBorderColor = widget.borderColor ?? Colors.transparent;
        // Hover: más saturado o más claro según el modo
        defaultHoverColor = isDark
            ? theme.colorScheme.primary.withValues(alpha: 0.9)
            : theme.colorScheme.primary.withValues(alpha: 0.85);
        break;

      case ButtonType.secondary:
      case ButtonType.outlined:
        defaultBgColor = widget.backgroundColor ?? Colors.transparent;
        defaultTextColor = widget.textColor ?? theme.colorScheme.primary;
        defaultBorderColor = widget.borderColor ?? theme.colorScheme.primary;
        defaultHoverColor = isDark
            ? theme.colorScheme.primary.withValues(alpha: 0.15)
            : theme.colorScheme.primary.withValues(alpha: 0.1);
        break;

      case ButtonType.danger:
        defaultBgColor = widget.backgroundColor ?? theme.colorScheme.error;
        defaultTextColor = widget.textColor ?? theme.colorScheme.onError;
        defaultBorderColor = widget.borderColor ?? Colors.transparent;
        defaultHoverColor = isDark
            ? theme.colorScheme.error.withValues(alpha: 0.9)
            : theme.colorScheme.error.withValues(alpha: 0.85);
        break;

      case ButtonType.text:
        defaultBgColor = widget.backgroundColor ?? Colors.transparent;
        defaultTextColor = widget.textColor ?? theme.colorScheme.primary;
        defaultBorderColor = widget.borderColor ?? Colors.transparent;
        defaultHoverColor = isDark
            ? theme.colorScheme.primary.withValues(alpha: 0.15)
            : theme.colorScheme.primary.withValues(alpha: 0.1);
        break;
    }

    // Ajustar opacidad si está deshabilitado
    final bgColor = widget.isEnabled
        ? defaultBgColor
        : defaultBgColor.withValues(alpha: 0.3);
    final txtColor = widget.isEnabled
        ? defaultTextColor
        : defaultTextColor.withValues(alpha: 0.5);
    final brdColor = widget.isEnabled
        ? defaultBorderColor
        : defaultBorderColor.withValues(alpha: 0.3);
    final hoverColor = widget.isEnabled ? defaultHoverColor : bgColor;

    return ElevatedButton.styleFrom(
      backgroundColor: bgColor,
      foregroundColor: txtColor,
      disabledBackgroundColor: bgColor,
      disabledForegroundColor: txtColor,
      elevation: widget.type == ButtonType.text ? 0 : 4,
      shadowColor: widget.type == ButtonType.text
          ? Colors.transparent
          : theme.colorScheme.shadow.withValues(alpha: 0.3),
      padding: widget.padding ?? _getDefaultPadding(),
      minimumSize: Size(_getWidth() ?? 0, widget.height ?? _getDefaultHeight()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        side:
            (widget.type == ButtonType.secondary ||
                widget.type == ButtonType.outlined)
            ? BorderSide(color: brdColor, width: 2)
            : BorderSide.none,
      ),
      textStyle: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return hoverColor;
        }
        if (states.contains(WidgetState.pressed)) {
          return hoverColor.withValues(alpha: 0.8);
        }
        return null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget button = ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton(
        onPressed: widget.isEnabled && !widget.isLoading ? _handlePress : null,
        onLongPress: widget.onLongPress,
        style: _getButtonStyle(context),
        child: _buildChild(context),
      ),
    );

    if (widget.size == ButtonSize.full || widget.width == double.infinity) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (widget.isLoading) {
      final theme = Theme.of(context);

      // Color del loader dinámico según el tipo de botón
      Color defaultLoaderColor;
      if (widget.type == ButtonType.primary) {
        defaultLoaderColor = theme.colorScheme.onPrimary;
      } else if (widget.type == ButtonType.danger) {
        defaultLoaderColor = theme.colorScheme.onError;
      } else {
        defaultLoaderColor = theme.colorScheme.primary;
      }

      return SizedBox(
        height: _getFontSize() + 4,
        width: _getFontSize() + 4,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.loadingColor ?? defaultLoaderColor,
          ),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: _getFontSize() + 4),
          const SizedBox(width: 10),
          Text(widget.text),
        ],
      );
    }

    return Text(widget.text);
  }
}

// Extensión para facilitar el uso con context
extension CustomButtonExtension on BuildContext {
  Widget primaryButton(
    String text,
    VoidCallback onPressed, {
    IconData? icon,
    bool isLoading = false,
    ButtonSize size = ButtonSize.medium,
    double? height,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      height: height
    );
  }

  Widget secondaryButton(
    String text,
    VoidCallback onPressed, {
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

  Widget dangerButton(
    String text,
    VoidCallback onPressed, {
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

  Widget textButton(
    String text,
    VoidCallback onPressed, {
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
