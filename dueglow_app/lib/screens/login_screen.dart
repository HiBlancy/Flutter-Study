import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../l10n/app_localizations.dart';

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
        Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          AppConstants.routeHome,
          (route) => false,
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
    final l10n = AppLocalizations.of(context)!;

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
              l10n.errorTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          customMessage ?? l10n.invalidUserOrPassword,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.accept,
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
    final l10n = AppLocalizations.of(context)!;
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
              l10n.exitAppTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            content: Text(
              l10n.exitAppQuestion,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  l10n.exit,
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
        ),
        child: Image.asset(
          'assets/logo.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,


        ),
      ),

      const SizedBox(height: 24),


      Text(
        'DueGlow',
        style: GoogleFonts.crimsonText(
          fontSize: 46,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: theme.colorScheme.primary,
        ),
      ),
      const SizedBox(height: 8),


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

      CustomTextField(
        controller: _emailController,
        label: AppLocalizations.of(context)!.email,
        hint: AppLocalizations.of(context)!.userEmailExample,
        prefixIcon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value?.isEmpty ?? true) return AppLocalizations.of(context)!.enterEmailAddress;
          if (!value!.contains('@') || !value.contains('.')) {
            return AppLocalizations.of(context)!.invalidAddress;
          }
          return null;
        },
      ),
      const SizedBox(height: 20),


      CustomTextField(
        controller: _passwordController,
        label: AppLocalizations.of(context)!.password,
        prefixIcon: Icons.lock_outline,
        obscureText: !_isPasswordVisible,
        showVisibilityToggle: true,
        onToggleVisibility: () {
          setState(() => _isPasswordVisible = !_isPasswordVisible);
        },
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value?.isEmpty ?? true) return AppLocalizations.of(context)!.enterPass;
          if (value!.length < 6) return AppLocalizations.of(context)!.pass6Char;
          return null;
        },
      ),
      const SizedBox(height: 12),


      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.comingSoon),
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.8,
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(
            AppLocalizations.of(context)!.forgotPassword,
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
      AppLocalizations.of(context)!.loginButtonUpper,
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
          '${AppLocalizations.of(context)!.dontHaveAccount} ',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/register'),
          child: Text(
            AppLocalizations.of(context)!.createOne,
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
                AppLocalizations.of(context)!.orContinueWith,
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


        Row(
          children: [

            Expanded(
              child: _socialButton(
                icon: Icons.g_mobiledata,
                label: 'Google',
                onPressed: () {},
                theme: theme,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: _socialButton(
                icon: Icons.apple,
                label: 'Apple',
                onPressed: () {},
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

