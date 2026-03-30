import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/main_toolbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _authService = AuthService();
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    final name = await _authService.getUserName();
    
    if (mounted) {
      setState(() {
        _userName = name ?? 'Usuario';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Skincare App',
      showDrawer: true,
      showBackButton: false,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¡Hola $_userName!',
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Bienvenido a Skincare App.\nTu aplicación para el cuidado de la piel.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildQuickActions(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  Icons.face,
                  'Rutina',
                  'Ver tu rutina',
                  () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  Icons.analytics,
                  'Progreso',
                  'Ver avances',
                  () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  Icons.science,
                  'Productos',
                  'Recomendaciones',
                  () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  Icons.calendar_today,
                  'Recordatorios',
                  'Configurar',
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}