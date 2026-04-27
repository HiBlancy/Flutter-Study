
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
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
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

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
    this.onChanged,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _internalFocusNode;
  late AnimationController _borderAnimationController;
  late Animation<Color?> _borderColorAnimation;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();

    _borderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _internalFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _borderAnimationController.dispose();
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    } else {
      _internalFocusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (_internalFocusNode.hasFocus) {
      _borderAnimationController.forward();
    } else {
      _borderAnimationController.reverse();
    }
  }

  void _buildBorderAnimation(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    final outlineColor = theme.colorScheme.outline;

    _borderColorAnimation = ColorTween(
      begin: outlineColor,
      end: primaryColor,
    ).animate(CurvedAnimation(
      parent: _borderAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    _buildBorderAnimation(theme);

    final subtleColor = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final errorColor = theme.colorScheme.error;

    return AnimatedBuilder(
      animation: _borderColorAnimation,
      builder: (context, child) {
        return TextFormField(
          controller: widget.controller,
          focusNode: _internalFocusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onChanged: (value) {
            setState(() {
              _hasError = false;
            });
            widget.onChanged?.call(value);
          },
          validator: (value) {
            final result = widget.validator?.call(value);
            if (result != null) {
              setState(() {
                _hasError = true;
              });
            }
            return result;
          },
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            letterSpacing: 0.3,
          ),
          cursorColor: theme.colorScheme.primary,
          cursorWidth: 2,
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: theme.textTheme.bodySmall?.copyWith(
              color: _internalFocusNode.hasFocus
                  ? theme.colorScheme.primary
                  : subtleColor,
              fontWeight: _internalFocusNode.hasFocus
                  ? FontWeight.w600
                  : FontWeight.w500,
            ),
            hintText: widget.hint,
            hintStyle: theme.textTheme.bodySmall?.copyWith(
              color: subtleColor.withValues(alpha: 0.4),
            ),


            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                widget.prefixIcon,
                color: _internalFocusNode.hasFocus
                    ? theme.colorScheme.primary
                    : subtleColor,
                size: 22,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),


            suffixIcon: widget.showVisibilityToggle
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      icon: Icon(
                        widget.obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _internalFocusNode.hasFocus
                            ? theme.colorScheme.primary
                            : subtleColor,
                        size: 22,
                      ),
                      onPressed: widget.onToggleVisibility,
                      splashRadius: 24,
                    ),
                  )
                : null,


            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 0,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError
                    ? errorColor
                    : subtleColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _hasError ? errorColor : theme.colorScheme.primary,
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorColor,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorColor,
                width: 2.5,
              ),
            ),


            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: errorColor,
              fontWeight: FontWeight.w500,
            ),


            filled: true,
            fillColor: _internalFocusNode.hasFocus
                ? (isDark
                    ? theme.colorScheme.primary.withValues(alpha: 0.08)
                    : theme.colorScheme.primary.withValues(alpha: 0.05))
                : Colors.transparent,


            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        );
      },
    );
  }
}