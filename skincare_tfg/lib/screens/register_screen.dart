import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/bottom_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      if (!_acceptTerms) _showErrorDialog('Debes aceptar los términos y condiciones');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authData = await _authService.register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (authData != null && mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: theme.colorScheme.onPrimary),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '¡Cuenta creada exitosamente!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: theme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            );
          }
        });
      } else if (mounted) {
        _showErrorDialog('Error al crear la cuenta. El correo podría estar registrado.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String message) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Error',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Aceptar',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? Color(0xff1a1419)
            : theme.colorScheme.surface,
        foregroundColor: isDark
            ? Color(0xfff4add8)
            : theme.colorScheme.onPrimary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? Color(0xfff4add8)
                : theme.colorScheme.primary,
          ),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(theme, isDark),
                  const SizedBox(height: 32),
                  _buildFormSection(theme),
                  const SizedBox(height: 24),
                  _buildTermsCheckbox(theme, isDark),
                  const SizedBox(height: 28),
                  _buildRegisterButton(theme),
                  const SizedBox(height: 30),
                  _buildSocialLogins(theme),
                  const SizedBox(height: 28),
                  _buildLoginLink(theme)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) => Container(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'DueGlow',
        style: theme.textTheme.displayLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.2,
          fontStyle: FontStyle.italic,
          fontSize: 40
        ),
      ),
      const SizedBox(height: 24),
      Text(
        'Crear Cuenta',
        style: theme.textTheme.displayLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.2,
          fontSize: 40
        ),
      ),
      Text(
        'Empieza a gestionar tus productos',
        style: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    ],
  ),
);

  Widget _buildFormSection(ThemeData theme) => Column(
    children: [
      // Campo de nombre
      CustomTextField(
        controller: _nameController,
        label: 'Nombre completo',
        hint: 'Tu nombre',
        prefixIcon: Icons.person_outline,
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Ingrese su nombre';
          if (value!.length < 3) return 'Mínimo 3 caracteres';
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Campo de email
      CustomTextField(
        controller: _emailController,
        label: 'Correo electrónico',
        hint: 'usuario@ejemplo.com',
        prefixIcon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Ingrese su correo';
          if (!value!.contains('@') || !value.contains('.')) {
            return 'Correo inválido';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Campo de contraseña
      CustomTextField(
        controller: _passwordController,
        label: 'Contraseña',
        prefixIcon: Icons.lock_outline,
        obscureText: !_isPasswordVisible,
        showVisibilityToggle: true,
        onToggleVisibility: () {
          setState(() => _isPasswordVisible = !_isPasswordVisible);
        },
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Ingrese su contraseña';
          if (value!.length < 6) return 'Mínimo 6 caracteres';
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Campo de confirmar contraseña
      CustomTextField(
        controller: _confirmPasswordController,
        label: 'Confirmar contraseña',
        prefixIcon: Icons.lock_outline,
        obscureText: !_isConfirmVisible,
        showVisibilityToggle: true,
        onToggleVisibility: () {
          setState(() => _isConfirmVisible = !_isConfirmVisible);
        },
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Confirme su contraseña';
          if (value != _passwordController.text) {
            return 'Las contraseñas no coinciden';
          }
          return null;
        },
      ),
    ],
  );

  Widget _buildTermsCheckbox(ThemeData theme, bool isDark) {
    final textColor = theme.colorScheme.onSurface.withValues(alpha: 0.7);
    final linkColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _acceptTerms,
            activeColor: theme.colorScheme.primary,
            checkColor: theme.colorScheme.onPrimary,
            side: BorderSide(
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
              width: 2,
            ),
            onChanged: (value) => setState(() => _acceptTerms = value ?? false),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _acceptTerms = !_acceptTerms),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                    children: [
                      const TextSpan(text: 'Acepto los '),
                      TextSpan(
                        text: 'términos y condiciones',
                        style: TextStyle(
                          color: linkColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' y la '),
                      TextSpan(
                        text: 'política de privacidad',
                        style: TextStyle(
                          color: linkColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(ThemeData theme) {
    return context.primaryButton(
      'CREAR CUENTA',
      _register,
      isLoading: _isLoading,
      size: ButtonSize.full,
      icon: Icons.person_add,
      height: 60,
    );
  }

   Widget _buildSocialLogins(ThemeData theme) {
    return Column(
      children: [
        // Divisor con texto "O"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'O continuar con',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Botones de Google y Apple
        Row(
          children: [
            // Botón Google
            Expanded(
              child: _socialButton(
                icon: Icons.g_mobiledata, // O puedes usar un FontAwesome/Asset
                label: 'Google',
                onPressed: () {}, // No funcional por ahora
                theme: theme,
              ),
            ),
            const SizedBox(width: 16),
            // Botón Apple
            Expanded(
              child: _socialButton(
                icon: Icons.apple,
                label: 'Apple',
                onPressed: () {}, // No funcional por ahoras
                theme: theme,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildLoginLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes una cuenta? ',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
          child: Text(
            'Inicia sesión',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}