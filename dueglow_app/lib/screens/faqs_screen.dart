import 'package:flutter/material.dart';
import '../widgets/main_toolbar.dart';
import '../l10n/app_localizations.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  static List<_FaqEntry> _faqEntries(AppLocalizations l10n) => [
        _FaqEntry(l10n.faqWhatIsAppQ, l10n.faqWhatIsAppA),
        _FaqEntry(l10n.faqAddProductQ, l10n.faqAddProductA),
        _FaqEntry(l10n.faqExpirationQ, l10n.faqExpirationA),
        _FaqEntry(l10n.faqProductListsQ, l10n.faqProductListsA),
        _FaqEntry(l10n.faqRoutinesQ, l10n.faqRoutinesA),
        _FaqEntry(l10n.faqScanNotFoundQ, l10n.faqScanNotFoundA),
        _FaqEntry(l10n.faqExpiringSoonQ, l10n.faqExpiringSoonA),
        _FaqEntry(l10n.faqOpenFinishQ, l10n.faqOpenFinishA),
        _FaqEntry(l10n.faqSettingsLangQ, l10n.faqSettingsLangA),
        _FaqEntry(l10n.faqDeleteAccountQ, l10n.faqDeleteAccountA),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final entries = _faqEntries(l10n);

    return CustomAppBar(
      title: l10n.faqs,
      showDrawer: true,
      showBackButton: true,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: entries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return _FaqTile(entry: entries[index], theme: theme);
        },
      ),
    );
  }
}

class _FaqEntry {
  final String question;
  final String answer;

  const _FaqEntry(this.question, this.answer);
}

class _FaqTile extends StatelessWidget {
  final _FaqEntry entry;
  final ThemeData theme;

  const _FaqTile({
    required this.entry,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final subtleText = theme.colorScheme.onSurface.withValues(alpha: 0.75);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: theme.colorScheme.primary,
        collapsedIconColor: theme.colorScheme.primary,
        title: Text(
          entry.question,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            height: 1.35,
          ),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: subtleText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
