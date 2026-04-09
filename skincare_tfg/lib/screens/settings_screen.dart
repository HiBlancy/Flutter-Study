import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/main_toolbar.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.colorScheme.onSurface.withValues(alpha: 0.1);

    return CustomAppBar(
      title: AppLocalizations.of(context)!.settings,
      showDrawer: true,
      showBackButton: true,
      child: ListView(
        children: [
          // ===== NOTIFICACIONES =====
          _SettingsSection(
            title: AppLocalizations.of(context)!.general, 
            children: [
            _NotificationTile(),
          ]),
          
          Divider(color: dividerColor, height: 1),
          
          // ===== TEMAS =====
          _SettingsSection(
            title: AppLocalizations.of(context)!.appearance,
            children: [
            _ThemeTile(),
          ]),
          
          Divider(color: dividerColor, height: 1),
          
          // ===== IDIOMAS =====
          _SettingsSection(
            title: AppLocalizations.of(context)!.language, 
            children: [
            _LanguageTile(),
          ]),
          
          Divider(color: dividerColor, height: 1),
          
          // ===== ACERCA DE =====
          _SettingsSection(
            title: AppLocalizations.of(context)!.information, 
            children: [
            _AboutTile(),
          ]),
        ],
      ),
    );
  }
}

// Widget para notificaciones
class _NotificationTile extends StatefulWidget {
  const _NotificationTile();

  @override
  State<_NotificationTile> createState() => _NotificationTileState();
}

class _NotificationTileState extends State<_NotificationTile> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: Icon(Icons.notifications, color: theme.colorScheme.primary),
      title: Text(l10n.notifications), 
      subtitle: Text(l10n.notifText, style: TextStyle(color: subtleText)),
      trailing: Switch(
        value: _notificationsEnabled,
        thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return theme.colorScheme.primary; // Color de tu marca cuando está activo
          }
          return null; // Devuelve null para usar el color por defecto cuando está inactivo
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return theme.colorScheme.primary.withValues(alpha: 0.5); 
          }
          return null; 
        }),
        onChanged: (bool value) {
          setState(() {
            _notificationsEnabled = value;
          });
          
          // Snackbar unificado con tu marca
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                value ? 'Notificaciones activadas' : 'Notificaciones desactivadas',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: theme.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}

// Widget para cambiar el tema
class _ThemeTile extends StatelessWidget {
  const _ThemeTile();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Opción Claro
        ListTile(
          leading: Icon(Icons.light_mode, color: theme.colorScheme.primary),
          title: Text(l10n.lightMode),
          trailing: themeProvider.themeMode == ThemeMode.light
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary) // Adiós Colors.green
              : null,
          onTap: () => themeProvider.setLightMode(),
        ),
        
        // Opción Oscuro
        ListTile(
          leading: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
          title: Text(l10n.darkMode),
          trailing: themeProvider.themeMode == ThemeMode.dark
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary) // Adiós Colors.green
              : null,
          onTap: () => themeProvider.setDarkMode(),
        ),
      ],
    );
  }
}

// Widget para cambiar el idioma
class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale.languageCode;
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    
    return Column(
      children: [
        // Español
        ListTile(
          leading: Icon(Icons.translate, color: theme.colorScheme.primary),
          title: const Text('Español'),
          subtitle: Text('Spanish', style: TextStyle(color: subtleText)),
          trailing: currentLocale == 'es'
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary) // Adiós Colors.green
              : null,
          onTap: () {
            localeProvider.setSpanish();
          },
        ),
        
        // Inglés
        ListTile(
          leading: Icon(Icons.translate, color: theme.colorScheme.primary),
          title: const Text('English'),
          subtitle: Text('Inglés', style: TextStyle(color: subtleText)),
          trailing: currentLocale == 'en'
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary) // Adiós Colors.green
              : null,
          onTap: () {
            localeProvider.setEnglish();
          },
        ),
      ],
    );
  }
}

// Widget para Acerca de
class _AboutTile extends StatelessWidget {
  const _AboutTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: Icon(Icons.info, color: theme.colorScheme.primary),
      title: Text(l10n.about),
      subtitle: Text('Versión 1.0.0', style: TextStyle(color: subtleText)),
      trailing: Icon(Icons.chevron_right, color: subtleText),
      onTap: () {
        // Navegar a la pantalla de About
        Navigator.pushNamed(context, '/about');
      },
    );
  }
}

// Sección con título
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8), // Más espacio arriba
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5, // Leve espaciado para que se vea más premium
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}