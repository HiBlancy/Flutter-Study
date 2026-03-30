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

  const CustomAppBar({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showDrawer = true,
    this.showBackButton = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
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
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(context),
            Expanded(
              child: ListView(
                children: [
                  // ANADIR COSAS SI SE QUIERE NAVEGAR DESDE EL LATERAL
                  // _buildDrawerItem(context, Icons.person, 'Mi Perfil', AppConstants.routeProfile),
                  // const Divider(),
                  _buildDrawerItem(context, Icons.settings, 'Configuración', AppConstants.routeSettings),
                  _buildDrawerItem(context, Icons.info, 'Acerca de', AppConstants.routeAbout),
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
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        final userName = snapshot.data?['name'] ?? 'Usuario';
        final userEmail = snapshot.data?['email'] ?? '';
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
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
    return {
      'name': name,
      'email': email,
    };
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String? route, {
    bool isLogout = false,
  }) {
    final authService = AuthService();
    
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : null),
      title: Text(title, style: TextStyle(color: isLogout ? Colors.red : null)),
      onTap: isLogout
          ? () async {
              Navigator.pop(context); // Cerrar drawer
              await authService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  AppConstants.routeLogin, 
                  (route) => false
                );
              }
            }
          : () {
              Navigator.pop(context); // Cerrar drawer
              Navigator.pushNamed(context, route!);
            },
    );
  }
}