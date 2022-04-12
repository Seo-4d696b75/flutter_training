import 'package:flutter/material.dart';
import 'package:hello_flutter/l10n/l10n.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    return AlertDialog(
      title: Text(
        l10n.errorDialogTitle,
        key: const Key("error_dialog_text_title"),
      ),
      content: Text(l10n.errorDialogMessage),
      actions: [
        TextButton(
          child: Text(l10n.errorDialogNegative),
          key: const Key("error_dialog_button_negative"),
          onPressed: () => Navigator.pop(context, ErrorDialogResult.close),
        ),
        TextButton(
          child: Text(l10n.errorDialogPositive),
          key: const Key("error_dialog_button_positive"),
          onPressed: () => Navigator.pop(context, ErrorDialogResult.reload),
        )
      ],
    );
  }
}

enum ErrorDialogResult { close, reload }
