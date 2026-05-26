import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import '../services/notifications_coordinator.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final token = await _authService.getToken();

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppConstants.routeLogin,
        (route) => false,
      );
      return;
    }

    if (!_authService.isTokenValid(token)) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppConstants.routeLogin,
        (route) => false,
      );
      return;
    }

    // Best-effort refresh user data in the background.
    Future(() async => _authService.getProfile());

    await NotificationsCoordinator.refresh();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppConstants.routeHome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      ),
    );
  }
}

