import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/bottom_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Precargar credenciales para desarrollo (ELIMINAR AL TERMINAR TESTEO)
    _emailController.text = 'blancy@gmail.com';
    _passwordController.text = '123456';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final authData = await _authService.login(email, password);

      setState(() => _isLoading = false);

      if (authData != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      } else if (mounted) {
        _showErrorDialog();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog([String? customMessage]) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 28),
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
          customMessage ?? 'Usuario o contraseña incorrectos',
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

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Salir de la app',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            content: Text(
              '¿Quieres salir de la aplicación?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  'Salir',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(theme, isDark),
                    const SizedBox(height: 48),
                    _buildFormSection(theme, isDark),
                    const SizedBox(height: 32),
                    _buildLoginButton(theme),
                    const SizedBox(height: 16),
                    _buildSocialLogins(theme),
                    const SizedBox(height: 40),
                    _buildRegisterLink(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) => Column(
    children: [
      // Logo/Icono decorativo
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
              : theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
          border: Border.all(
            color: isDark
                ? theme.colorScheme.primary.withValues(alpha: 0.3)
                : theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 4,
          ),
        ), // Para asegurar que la imagen se mantenga circular si es necesario
        child: Image.asset(
          'assets/logo.png', // <--- LA RUTA DE TU LOGO
          width: 120, // Ajusta el tamaño aquí
          height: 120,
          fit: BoxFit.contain,
          // Si quieres que el logo cambie de color según el tema (solo si es un PNG plano/icono)
          // color: theme.colorScheme.primary,
        ),
      ),

      const SizedBox(height: 24),

      // Título
      Text(
        'DueGlow',
        style: theme.textTheme.displayLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
          fontStyle: FontStyle.italic
        ),
      ),
      const SizedBox(height: 8),

      // Subtítulo
      Text(
        'Tu rutina de belleza personalizada',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );

  Widget _buildFormSection(ThemeData theme, bool isDark) => Column(
    children: [
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
      const SizedBox(height: 20),

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
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value?.isEmpty ?? true) return 'Ingrese su contraseña';
          if (value!.length < 6) return 'Mínimo 6 caracteres';
          return null;
        },
      ),
      const SizedBox(height: 12),

      // Link "Olvidé mi contraseña"
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            // TODO: Implementar recuperación de contraseña
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Función próximamente disponible'),
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.8,
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(
            '¿Olvidaste tu contraseña?',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildLoginButton(ThemeData theme) {
    return context.primaryButton(
      'INICIAR SESIÓN',
      _login,
      isLoading: _isLoading,
      size: ButtonSize.full,
      icon: Icons.login_outlined,
      height: 60,
    );
  }

  Widget _buildRegisterLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta? ',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/register'),
          child: Text(
            'Crear una',
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
}
