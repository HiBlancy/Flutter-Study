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

          _SettingsSection(
            title: AppLocalizations.of(context)!.general,
            children: [
            _NotificationTile(),
          ]),

          Divider(color: dividerColor, height: 1),


          _SettingsSection(
            title: AppLocalizations.of(context)!.appearance,
            children: [
            _ThemeTile(),
          ]),

          Divider(color: dividerColor, height: 1),


          _SettingsSection(
            title: AppLocalizations.of(context)!.language,
            children: [
            _LanguageTile(),
          ]),

          Divider(color: dividerColor, height: 1),


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
            return theme.colorScheme.primary;
          }
          return null;
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


          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                value ? l10n.notificationsEnabled : l10n.notificationsDisabled,
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


class _ThemeTile extends StatelessWidget {
  const _ThemeTile();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [

        ListTile(
          leading: Icon(Icons.light_mode, color: theme.colorScheme.primary),
          title: Text(l10n.lightMode),
          trailing: themeProvider.themeMode == ThemeMode.light
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
              : null,
          onTap: () => themeProvider.setLightMode(),
        ),


        ListTile(
          leading: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
          title: Text(l10n.darkMode),
          trailing: themeProvider.themeMode == ThemeMode.dark
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
              : null,
          onTap: () => themeProvider.setDarkMode(),
        ),
      ],
    );
  }
}


class _LanguageTile extends StatelessWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale.languageCode;
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [

        ListTile(
          leading: Icon(Icons.translate, color: theme.colorScheme.primary),
          title: Text(l10n.spanish),
          subtitle: Text(l10n.english, style: TextStyle(color: subtleText)),
          trailing: currentLocale == 'es'
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
              : null,
          onTap: () {
            localeProvider.setSpanish();
          },
        ),


        ListTile(
          leading: Icon(Icons.translate, color: theme.colorScheme.primary),
          title: Text(l10n.english),
          subtitle: Text(l10n.spanish, style: TextStyle(color: subtleText)),
          trailing: currentLocale == 'en'
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
              : null,
          onTap: () {
            localeProvider.setEnglish();
          },
        ),


        ListTile(
          leading: Icon(Icons.translate, color: theme.colorScheme.primary),
          title: Text(l10n.russian),
          subtitle: Text(l10n.english, style: TextStyle(color: subtleText)),
          trailing: currentLocale == 'ru'
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
              : null,
          onTap: () {
            localeProvider.setRussian();
          },
        ),
      ],
    );
  }
}


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
      subtitle: Text(l10n.versionLabel('1.0.0'), style: TextStyle(color: subtleText)),
      trailing: Icon(Icons.chevron_right, color: subtleText),
      onTap: () {

        Navigator.pushNamed(context, '/about');
      },
    );
  }
}


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
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}