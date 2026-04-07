import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/bottom_app_bar.dart';  // Cambiar esta importación

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

//ELIMINAR AL TERMINAR TESTEO
  @override
  void initState() {
    super.initState();
    // Precargar credenciales para desarrollo
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
        // Cambiar aquí: navegar a BottomNavBar en lugar de HomeScreen
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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error de inicio de sesión'),
        content: Text(customMessage ?? 'Usuario o contraseña incorrectos'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Salir de la app'),
            content: const Text('¿Quieres salir de la aplicación?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Salir'),
              ),
            ],
          ),
        );
        return confirm ?? false;
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
                    _buildHeader(),
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
                        setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        );
                      },
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value?.isEmpty ?? true)
                          return 'Ingrese su contraseña';
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

  Widget _buildHeader() => const Column(
    children: [
      Text(
        'Skincare App',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Text(
        'Inicia sesión para continuar',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
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