import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/bottom_app_bar.dart';
import '../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate() || !_acceptTerms) {
      if (!_acceptTerms) _showErrorDialog(l10n.mustAcceptTerms);
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
                Expanded(
                  child: Text(
                    l10n.accountCreatedSuccess,
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
        _showErrorDialog(l10n.createAccountErrorMaybeEmail);
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
    final l10n = AppLocalizations.of(context)!;

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
              l10n.errorTitle,
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
        AppLocalizations.of(context)!.createAcount,
        style: theme.textTheme.displayLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.2,
          fontSize: 40
        ),
      ),
      Text(
        AppLocalizations.of(context)!.startManagingProducts,
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

      CustomTextField(
        controller: _nameController,
        label: AppLocalizations.of(context)!.fullName,
        hint: AppLocalizations.of(context)!.enterName,
        prefixIcon: Icons.person_outline,
        validator: (value) {
          if (value?.isEmpty ?? true) return AppLocalizations.of(context)!.enterName;
          if (value!.length < 3) return AppLocalizations.of(context)!.min3Chars;
          return null;
        },
      ),
      const SizedBox(height: 16),


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
      const SizedBox(height: 16),


      CustomTextField(
        controller: _passwordController,
        label: AppLocalizations.of(context)!.password,
        prefixIcon: Icons.lock_outline,
        obscureText: !_isPasswordVisible,
        showVisibilityToggle: true,
        onToggleVisibility: () {
          setState(() => _isPasswordVisible = !_isPasswordVisible);
        },
        validator: (value) {
          if (value?.isEmpty ?? true) return AppLocalizations.of(context)!.enterPass;
          if (value!.length < 6) return AppLocalizations.of(context)!.pass6Char;
          return null;
        },
      ),
      const SizedBox(height: 16),


      CustomTextField(
        controller: _confirmPasswordController,
        label: AppLocalizations.of(context)!.confirmPassword,
        prefixIcon: Icons.lock_outline,
        obscureText: !_isConfirmVisible,
        showVisibilityToggle: true,
        onToggleVisibility: () {
          setState(() => _isConfirmVisible = !_isConfirmVisible);
        },
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value?.isEmpty ?? true) return AppLocalizations.of(context)!.confirmYourPassword;
          if (value != _passwordController.text) {
            return AppLocalizations.of(context)!.passwordsDontMatch;
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
                      TextSpan(text: AppLocalizations.of(context)!.acceptTermsPrefix),
                      TextSpan(
                        text: AppLocalizations.of(context)!.termsAndConditions,
                        style: TextStyle(
                          color: linkColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(text: AppLocalizations.of(context)!.andThe),
                      TextSpan(
                        text: AppLocalizations.of(context)!.privacyPolicy,
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
      AppLocalizations.of(context)!.createAccountUpper,
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

  Widget _buildLoginLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${AppLocalizations.of(context)!.alreadyHaveAccount} ',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
          child: Text(
            AppLocalizations.of(context)!.signIn,
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