import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/notification_preferences_provider.dart';
import '../services/auth_service.dart';
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
            children: const [
              _NotificationsSection(),
            ],
          ),

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

          Divider(color: dividerColor, height: 1),

          _SettingsSection(
            title: AppLocalizations.of(context)!.deleteAccountSectionTitle,
            children: [
              const _DeleteAccountTile(),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}


class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationPreferencesProvider>(
      builder: (context, provider, _) {
        if (!provider.isLoaded) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = Theme.of(context);
        final l10n = AppLocalizations.of(context)!;
        final s = provider.settings;

        return Column(
          children: [
            _NotificationSwitchTile(
              icon: Icons.notifications_active_outlined,
              title: l10n.notifications,
              subtitle: l10n.notifMasterSubtitle,
              value: s.masterEnabled,
              onChanged: (v) => _toggle(context, () => provider.setMasterEnabled(v), v, l10n),
            ),
            if (s.masterEnabled) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  l10n.notifTypesHeader,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _NotificationSwitchTile(
                icon: Icons.event_busy_outlined,
                title: l10n.notifExpirationTitle,
                subtitle: l10n.notifExpirationSubtitle,
                value: s.expirationEnabled,
                enabled: s.masterEnabled,
                onChanged: (v) =>
                    _toggle(context, () => provider.setExpirationEnabled(v), v, l10n),
              ),
              _NotificationSwitchTile(
                icon: Icons.schedule_outlined,
                title: l10n.notifRoutinesTitle,
                subtitle: l10n.notifRoutinesSubtitle,
                value: s.routinesEnabled,
                enabled: s.masterEnabled,
                onChanged: (v) =>
                    _toggle(context, () => provider.setRoutinesEnabled(v), v, l10n),
              ),
              _NotificationSwitchTile(
                icon: Icons.calendar_view_week_outlined,
                title: l10n.notifWeeklyTitle,
                subtitle: l10n.notifWeeklySubtitle,
                value: s.weeklyDigestEnabled,
                enabled: s.masterEnabled,
                onChanged: (v) =>
                    _toggle(context, () => provider.setWeeklyDigestEnabled(v), v, l10n),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _toggle(
    BuildContext context,
    Future<void> Function() action,
    bool value,
    AppLocalizations l10n,
  ) async {
    await action();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? l10n.notificationsEnabled : l10n.notificationsDisabled),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _NotificationSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _NotificationSwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.enabled = true,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: subtleText, height: 1.35)),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
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
    final resolvedBrightness = theme.brightness;

    final l10n = AppLocalizations.of(context)!;

    // ThemeMode.system follows the device; settings only lists light/dark, so
    // mark the row that matches what the user actually sees.
    final mode = themeProvider.themeMode;
    final lightSelected = mode == ThemeMode.light ||
        (mode == ThemeMode.system && resolvedBrightness == Brightness.light);
    final darkSelected = mode == ThemeMode.dark ||
        (mode == ThemeMode.system && resolvedBrightness == Brightness.dark);

    return Column(
      children: [

        ListTile(
          leading: Icon(Icons.light_mode, color: theme.colorScheme.primary),
          title: Text(l10n.lightMode),
          trailing: lightSelected
              ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
              : null,
          onTap: () => themeProvider.setLightMode(),
        ),


        ListTile(
          leading: Icon(Icons.dark_mode, color: theme.colorScheme.primary),
          title: Text(l10n.darkMode),
          trailing: darkSelected
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
          subtitle: Text('Español', style: TextStyle(color: subtleText)),
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
          subtitle: Text('English', style: TextStyle(color: subtleText)),
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
          subtitle: Text('Русский', style: TextStyle(color: subtleText)),
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


class _DeleteAccountTile extends StatefulWidget {
  const _DeleteAccountTile();

  @override
  State<_DeleteAccountTile> createState() => _DeleteAccountTileState();
}

class _DeleteAccountTileState extends State<_DeleteAccountTile> {
  bool _busy = false;

  Future<void> _confirmAndDelete() async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.warning_amber_rounded,
            color: theme.colorScheme.error,
            size: 40,
          ),
          title: Text(l10n.deleteAccountDialogTitle),
          content: SingleChildScrollView(
            child: Text(l10n.deleteAccountDialogMessage),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: Text(l10n.deleteAccountConfirmButton),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                ),
                Expanded(child: Text(l10n.deleteAccountDeleting)),
              ],
            ),
          ),
        );
      },
    );

    final ok = await AuthService().deleteAccount();

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (!mounted) return;
    setState(() => _busy = false);

    if (ok) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppConstants.routeLogin,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.deleteAccountError),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return ListTile(
      enabled: !_busy,
      leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
      title: Text(
        l10n.deleteAccount,
        style: TextStyle(
          color: theme.colorScheme.error,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        l10n.deleteAccountSubtitle,
        style: TextStyle(color: subtleText),
      ),
      onTap: _busy ? null : _confirmAndDelete,
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