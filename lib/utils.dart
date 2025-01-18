import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showProcessingDialog(BuildContext context) async {
    final SimpleDialog dialog = SimpleDialog(
      backgroundColor: Colors.black12,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text(
                "Processing...",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return PopScope(child: dialog);
      },
    );
  }
}
