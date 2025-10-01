import 'package:flutter/material.dart';

/// A reusable confirmation dialog widget for various confirmation scenarios.
///
/// This widget provides a consistent UI for confirmation dialogs across the app,
/// with customizable title, content, and action buttons.
class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.isDestructive = false,
  });

  /// The title of the dialog
  final String title;

  /// The content/message of the dialog. Can be a String or Widget.
  final Object content;

  /// The text for the confirm button (defaults to 'Confirm')
  final String confirmText;

  /// The text for the cancel button (defaults to 'Cancel')
  final String cancelText;

  /// Callback when confirm is pressed. If null, dialog just closes.
  final VoidCallback? onConfirm;

  /// Whether this is a destructive action (e.g., delete). Styles confirm button in red.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content is String ? Text(content as String) : content as Widget,
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(cancelText)),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
          style: isDestructive ? TextButton.styleFrom(foregroundColor: Colors.red) : null,
          child: Text(confirmText),
        ),
      ],
    );
  }
}

/// Helper function to show a confirmation dialog
Future<void> showConfirmationDialog({
  // TODO: search through code to see if we can use this elsewhere
  required BuildContext context,
  required String title,
  required Object content,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  bool isDestructive = false,
}) {
  return showDialog(
    context: context,
    builder: (context) => ConfirmationDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      isDestructive: isDestructive,
    ),
  );
}
