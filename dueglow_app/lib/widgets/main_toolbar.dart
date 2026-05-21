import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  /// When set, replaces the default [title] text (e.g. branded app mark).
  final Widget? titleWidget;
  final Widget child;
  final List<Widget>? actions;
  final bool showDrawer;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;
  final Color? appBarColor;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    required this.child,
    this.actions,
    this.showDrawer = true,
    this.showBackButton = false,
    this.bottom,
    this.appBarColor,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = appBarColor ?? theme.appBarTheme.backgroundColor;
    final foregroundColor = theme.appBarTheme.foregroundColor;

    return Scaffold(
      appBar: AppBar(
        title: titleWidget ??
            Text(title, style: TextStyle(color: foregroundColor)),
        centerTitle: true,
        backgroundColor: backgroundColor,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: foregroundColor),
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack ?? () => Navigator.pop(context),
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
  final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context)!;
  return Drawer(
    backgroundColor: theme.colorScheme.surface,
    child: SafeArea(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  context,
                  Icons.settings,
                  l10n.settings,
                  AppConstants.routeSettings,
                ),
                _buildDrawerItem(
                  context,
                  Icons.edit,
                  l10n.editProfile,
                  AppConstants.routeEdit,
                ),
                _buildDrawerItem(
                  context,
                  Icons.info,
                  l10n.about,
                  AppConstants.routeAbout,
                ),
                _buildDrawerItem(
                  context,
                  Icons.question_answer_outlined,
                  l10n.faqs,
                  AppConstants.routeFAQs,
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  Icons.logout,
                  l10n.logout,
                  null,
                  isLogout: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.versionLabel(AppConstants.version),
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDrawerHeader(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Map<String, String?>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        final l10n = AppLocalizations.of(context)!;
        final userName = snapshot.data?['name'] ?? l10n.defaultUserName;
        final userEmail = snapshot.data?['email'] ?? '';
        final profileImage = snapshot.data?['profileImage'];

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.onPrimary,
              backgroundImage: profileImage != null && profileImage.isNotEmpty
                  ? NetworkImage(profileImage)
                  : null,
              child: profileImage == null || profileImage.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: theme.colorScheme.primary,
                    )
                  : null,
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sora',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontFamily: 'Lato',
                ),
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
    final profileImage = await authService.getUserProfileImage();
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage
      };
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String? route, {
    bool isLogout = false,
  }) {
    final theme = Theme.of(context);
    final authService = AuthService();


    final Color itemColor = isLogout ? theme.colorScheme.error : theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontFamily: 'Lato',
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: isLogout
          ? () async {
              Navigator.pop(context);
              await authService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppConstants.routeLogin,
                  (route) => false,
                );
              }
            }
          : () {
              Navigator.pop(context);
              Navigator.pushNamed(context, route!);
            },
    );
  }
}