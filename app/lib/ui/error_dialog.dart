import 'package:flutter/material.dart';
import 'package:hello_flutter/data/strings.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.errorDialogTitle),
      content: const Text(Strings.errorDialogMessage),
      actions: [
        TextButton(
          child: const Text(Strings.errorDialogNegative),
          onPressed: () => Navigator.pop(context, ErrorDialogResult.close),
        ),
        TextButton(
          child: const Text(Strings.errorDialogPositive),
          onPressed: () => Navigator.pop(context, ErrorDialogResult.reload),
        )
      ],
    );
  }
}

enum ErrorDialogResult { close, reload }
