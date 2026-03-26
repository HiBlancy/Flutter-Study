// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/main_toolbar.dart';
import '../widgets/bottom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await _authService.getUserName();
    if (mounted) {
      setState(() {
        _userName = name ?? 'Usuario';
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    // El body que se pasa al BottomNavBar debe ser el contenido de la pantalla actual
    // El BottomNavBar se encargará de la navegación entre pantallas
    return BottomNavBar(
      initialIndex: 0,
      body: CustomAppBar(
        title: 'MiAppName',
        showDrawer: true,
        showBackButton: false,
        child: HomeContent(userName: _userName),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final String userName;

  const HomeContent({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '¡Hola $userName!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Has iniciado sesión correctamente.\nPróximamente conectaremos con una base de datos.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}