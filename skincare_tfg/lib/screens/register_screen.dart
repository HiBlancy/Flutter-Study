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
      if (!_acceptTerms) _showErrorDialog('Debes aceptar los términos');
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
            content: const Text('¡Cuenta creada exitosamente!', style: TextStyle(color: Colors.white)),
            backgroundColor: theme.colorScheme.primary, // Adaptado al color de tu app
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
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
        title: Text('Error', style: theme.textTheme.titleLarge),
        content: Text(
          message,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
                  _buildHeader(theme),
                  const SizedBox(height: 40),
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
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Ingrese su contraseña';
                      if (value!.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 20),
                  _buildTermsCheckbox(theme),
                  const SizedBox(height: 24),
                  _buildRegisterButton(),
                  const SizedBox(height: 20),
                  _buildLoginLink(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: theme.colorScheme.primary.withValues(alpha: 0.1),
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.person_add,
      size: 60,
      color: theme.colorScheme.primary,
    ),
  );

  Widget _buildTermsCheckbox(ThemeData theme) {
    final textColor = theme.colorScheme.onSurface.withValues(alpha: 0.7);
    final linkColor = theme.colorScheme.primary; // Reemplaza al azul por defecto

    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          activeColor: theme.colorScheme.primary,
          onChanged: (value) => setState(() => _acceptTerms = value ?? false),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _acceptTerms = !_acceptTerms),
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(color: textColor),
                children: [
                  const TextSpan(text: 'Acepto los '),
                  TextSpan(
                    text: 'términos y condiciones',
                    style: TextStyle(color: linkColor, fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' y la '),
                  TextSpan(
                    text: 'política de privacidad',
                    style: TextStyle(color: linkColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return context.primaryButton(
      'Crear Cuenta',
      _register,
      isLoading: _isLoading,
      size: ButtonSize.full,
      icon: Icons.person_add,
    );
  }

  Widget _buildLoginLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes una cuenta? ',
          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        context.textButton(
          'Iniciar Sesión',
          () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ],
    );
  }
}