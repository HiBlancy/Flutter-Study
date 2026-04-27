
import 'package:flutter/material.dart';

class WarningDialog {
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Continuar',
    String cancelText = 'Cancelar',
    bool isDanger = false,
  }) async {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withOpacity(0.7);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),

          side: theme.brightness == Brightness.dark
              ? BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.1))
              : BorderSide.none,
        ),
        title: Row(
          children: [
            Icon(
              isDanger ? Icons.warning_amber : Icons.info_outline,
              color: isDanger ? theme.colorScheme.error : theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),

            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(color: subtleText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,

              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDanger
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              foregroundColor: isDanger
                  ? theme.colorScheme.onError
                  : theme.colorScheme.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String content,
  }) async {
    final theme = Theme.of(context);
    final subtleText = theme.colorScheme.onSurface.withOpacity(0.7);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: theme.brightness == Brightness.dark
              ? BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.1))
              : BorderSide.none,
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(color: subtleText),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}