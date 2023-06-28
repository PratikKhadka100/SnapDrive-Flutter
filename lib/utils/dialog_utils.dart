import 'package:flutter/material.dart';

class DialogUtils {
  static void showDialogHandler(
      BuildContext context, Widget title, Widget content, Function onTap) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: title,
        content: content,
        actions: [
          MaterialButton(
            color: Theme.of(ctx).primaryColor,
            onPressed: () => onTap(),
            child: const Text(
              'Ok',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
