// lib/widgets/main_toolbar.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final Widget child; // Cambiado de 'body' a 'child'
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  final bool showDrawer;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.showDrawer = true,
    this.showBackButton = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _authService = AuthService();
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await _authService.getUserName();
    final email = await _authService.getUserEmail();
    if (mounted) {
      setState(() {
        _userName = name ?? 'Usuario';
        _userEmail = email ?? '';
      });
    }
  }

  void _navigateTo(String route) {
    _scaffoldKey.currentState?.closeEndDrawer();
    if (mounted) {
      Navigator.pushNamed(context, route);
    }
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: widget.centerTitle,
        backgroundColor: widget.backgroundColor,
        leading: widget.showBackButton 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goBack,
                tooltip: 'Atrás',
              )
            : null,
        actions: [
          ...?widget.actions,
          if (widget.showDrawer)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              tooltip: 'Menú',
            ),
        ],
      ),
      endDrawer: widget.showDrawer ? _buildDrawer() : null,
      body: widget.child,
    );
  }

  Widget _buildDrawer() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.home, 'Inicio', '/home', currentRoute == '/home'),
                  const Divider(),
                  _buildDrawerItem(Icons.person, 'Mi Perfil', '/profile', currentRoute == '/profile'),
                  _buildDrawerItem(Icons.settings, 'Configuración', '/settings', currentRoute == '/settings'),
                  _buildDrawerItem(Icons.info, 'Acerca de', '/about', currentRoute == '/about'),
                  const Divider(),
                  _buildDrawerItem(
                    Icons.logout, 
                    'Cerrar sesión', 
                    null,
                    false,
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    isLogout: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Versión 1.0.0', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 40, color: Colors.blue),
          ),
          const SizedBox(height: 12),
          Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_userEmail, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    String? route,
    bool isSelected, {
    Color? iconColor,
    Color? textColor,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      tileColor: isSelected ? Colors.grey.shade100 : null,
      onTap: isLogout
          ? () async {
              _scaffoldKey.currentState?.closeEndDrawer();
              await _authService.logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            }
          : () => _navigateTo(route!),
    );
  }
}