// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Configuración',
      showDrawer: true,
      showBackButton: true,
      child: SettingsContent(
        notificationsEnabled: _notificationsEnabled,
        darkModeEnabled: _darkModeEnabled,
        onNotificationsChanged: (value) {
          setState(() {
            _notificationsEnabled = value;
          });
        },
        onDarkModeChanged: (value) {
          setState(() {
            _darkModeEnabled = value;
          });
        },
        onLanguageTap: () {
          _showLanguageDialog();
        },
        onStorageTap: () {
          _showStorageDialog();
        },
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar idioma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Español'),
                onTap: () {
                  Navigator.pop(context);
                  // Aquí iría la lógica para cambiar idioma
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Navigator.pop(context);
                  // Aquí iría la lógica para cambiar idioma
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStorageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Almacenamiento'),
          content: const Text('Gestión de almacenamiento próximamente'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

class SettingsContent extends StatelessWidget {
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final ValueChanged<bool> onDarkModeChanged;
  final VoidCallback onLanguageTap;
  final VoidCallback onStorageTap;

  const SettingsContent({
    super.key,
    required this.notificationsEnabled,
    required this.darkModeEnabled,
    required this.onNotificationsChanged,
    required this.onDarkModeChanged,
    required this.onLanguageTap,
    required this.onStorageTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Notificaciones'),
          subtitle: const Text('Recibir notificaciones push'),
          value: notificationsEnabled,
          onChanged: onNotificationsChanged,
        ),
        SwitchListTile(
          title: const Text('Modo oscuro'),
          subtitle: const Text('Activar tema oscuro'),
          value: darkModeEnabled,
          onChanged: onDarkModeChanged,
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Idioma'),
          subtitle: const Text('Español'),
          onTap: onLanguageTap,
        ),
        ListTile(
          leading: const Icon(Icons.data_usage),
          title: const Text('Almacenamiento'),
          subtitle: const Text('Gestionar datos'),
          onTap: onStorageTap,
        ),
      ],
    );
  }
}