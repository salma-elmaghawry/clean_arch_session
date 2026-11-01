import 'package:flutter/material.dart';

// Once a permission is blocked the system won't ask the user again, so we
// explain why we need it and take them to where they can turn it on.
Future<void> showOpenSettingsDialog(
  BuildContext context, {
  required String title,
  required String message,
  required Future<bool> Function() openSettings,
}) async {
  final shouldOpen = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Not now'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Open settings'),
        ),
      ],
    ),
  );
  if (shouldOpen == true) await openSettings();
}
