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
        title: Text('Error', style: theme.textTheme.titleLarge),
        content: Text(
          customMessage ?? 'Usuario o contraseña incorrectos',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7)
          )
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Aceptar', style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Salir de la app', style: theme.textTheme.titleLarge),
            content: Text(
              '¿Quieres salir de la aplicación?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7)
              )
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Salir', style: TextStyle(color: theme.colorScheme.error)),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    _buildHeader(theme),
                    const SizedBox(height: 40),
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
                    const SizedBox(height: 24),
                    _buildLoginButton(),
                    const SizedBox(height: 16),
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) => Column(
    children: [
      Text(
        'DueGlow',
        style: theme.textTheme.displayLarge?.copyWith(
          color: theme.colorScheme.primary, // Toma el color magenta/ciruela
        ),
      ),
//LOGOOOOOO CUANDO LO TENGAAA
    ],
  );

  Widget _buildLoginButton() {
    return context.primaryButton(
      'Iniciar Sesión',
      _login,
      isLoading: _isLoading,
      size: ButtonSize.full,
      icon: Icons.person_add,
    );
  }

  Widget _buildRegisterButton() {
    return context.secondaryButton(
      'Crear Cuenta',
      () => Navigator.pushNamed(context, '/register'),
      size: ButtonSize.full,
    );
  }
}