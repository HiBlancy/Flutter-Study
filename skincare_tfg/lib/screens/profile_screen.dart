// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/main_toolbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        _userEmail = email ?? 'usuario@ejemplo.com';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Mi Perfil',
      showDrawer: true,
      showBackButton: true,
      body: ProfileContent(
        userName: _userName,
        userEmail: _userEmail,
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileContent({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 70,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            userName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(context, Icons.email, 'Correo electrónico', userEmail),
                  const Divider(),
                  _buildInfoRow(context, Icons.phone, 'Teléfono', '+34 123 456 789'),
                  const Divider(),
                  _buildInfoRow(context, Icons.cake, 'Fecha de nacimiento', '01/01/1990'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}