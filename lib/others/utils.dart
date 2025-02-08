import 'package:flutter/material.dart';

/// Utilities class
class Utilities {
  static Future<void> showProcessingDialog(BuildContext context) async {
    final SimpleDialog dialog = SimpleDialog(
      backgroundColor: Colors.white70,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              "Processing...",
            ),
          ],
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

  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}
