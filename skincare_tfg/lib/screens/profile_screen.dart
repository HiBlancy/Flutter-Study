import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    final name = await _authService.getUserName();
    final email = await _authService.getUserEmail();
    
    if (mounted) {
      setState(() {
        _userName = name ?? 'Usuario';
        _userEmail = email ?? 'usuario@ejemplo.com';
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
      title: 'Mi Perfil',
      showDrawer: true,
      showBackButton: false,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildProfileAvatar(),
                    const SizedBox(height: 24),
                    _buildUserName(),
                    const SizedBox(height: 8),
                    _buildUserEmail(),
                    const SizedBox(height: 24),
                    _buildInfoCard(),
                    const SizedBox(height: 20),
                    _buildEditButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.person, size: 70, color: Colors.white),
    );
  }

  Widget _buildUserName() {
    return Text(
      _userName,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildUserEmail() {
    return Text(
      _userEmail,
      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(Icons.email, 'Correo electrónico', _userEmail),
            const Divider(),
            _buildInfoRow(Icons.phone, 'Teléfono', '+34 123 456 789'),
            const Divider(),
            _buildInfoRow(Icons.cake, 'Fecha de nacimiento', '01/01/1990'),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: context.secondaryButton(
        'Editar Perfil',
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Próximamente')),
          );
        },
        size: ButtonSize.full,
        icon: Icons.edit,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}