import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../constants/app_constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool showDrawer;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;
  final Color? appBarColor;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showDrawer = true,
    this.showBackButton = false,
    this.bottom,
    this.appBarColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = appBarColor ?? theme.appBarTheme.backgroundColor;
    final foregroundColor = theme.appBarTheme.foregroundColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: foregroundColor)),
        centerTitle: true,
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: foregroundColor),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          ...?actions,
          if (showDrawer)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
        ],
        bottom: bottom,
      ),
      endDrawer: showDrawer ? _buildDrawer(context) : null,
      body: child,
    );
  }

  Widget _buildDrawer(BuildContext context) {
  final theme = Theme.of(context);
  return Drawer(
    backgroundColor: theme.colorScheme.surface,
    child: SafeArea(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  context,
                  Icons.settings,
                  'Configuración',
                  AppConstants.routeSettings,
                ),
                _buildDrawerItem(
                  context,
                  Icons.edit,
                  'Editar Perfil',
                  AppConstants.routeEdit,
                ),
                _buildDrawerItem(
                  context,
                  Icons.info,
                  'Acerca de',
                  AppConstants.routeAbout,
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  Icons.logout,
                  'Cerrar sesión',
                  null,
                  isLogout: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Versión ${AppConstants.version}',
              style: TextStyle(
                fontSize: 12, 
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDrawerHeader(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Map<String, String?>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        final userName = snapshot.data?['name'] ?? 'Usuario';
        final userEmail = snapshot.data?['email'] ?? '';
        final profileImage = snapshot.data?['profileImage'];

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary, // ✅ Ciruela oscuro en Light / Blanco hueso en Dark
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.onPrimary,
              backgroundImage: profileImage != null && profileImage.isNotEmpty
                  ? NetworkImage(profileImage)
                  : null,
              child: profileImage == null || profileImage.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: theme.colorScheme.primary,
                    )
                  : null,
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary, // ✅ Texto blanco en Light / Negro en Dark
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sora',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.8), // ✅ Email legible
                  fontSize: 12,
                  fontFamily: 'Lato',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, String?>> _getUserData() async {
    final authService = AuthService();
    final name = await authService.getUserName();
    final email = await authService.getUserEmail();
    final profileImage = await authService.getUserProfileImage(); 
    return {
      'name': name, 
      'email': email,
      'profileImage': profileImage
      };
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String? route, {
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);
    final authService = AuthService();
    
    // ✅ Color dinámico para los items del menú
    final Color itemColor = isLogout ? theme.colorScheme.error : theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(
        title, 
        style: TextStyle(
          color: itemColor,
          fontFamily: 'Lato',
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: isLogout
          ? () async {
              Navigator.pop(context);
              await authService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppConstants.routeLogin,
                  (route) => false,
                );
              }
            }
          : () {
              Navigator.pop(context);
              Navigator.pushNamed(context, route!);
            },
    );
  }
}