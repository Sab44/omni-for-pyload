import 'package:flutter/material.dart';

/// Reusable function to show an error dialog with a warning icon.
///
/// This can be used across the app to display error messages in a consistent
/// dialog format.
Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        Icons.warning_rounded,
        color: Theme.of(context).colorScheme.error,
        size: 48,
      ),
      title: Text(
        'Error',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      ],
    ),
  );
}
