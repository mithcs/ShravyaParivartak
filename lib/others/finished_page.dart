import 'package:flutter/material.dart';

/// Finished page, page after conversion
class FinishedPage extends StatelessWidget {
  const FinishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success!'),
      ),
      body: FinishedPageBody(),
    );
  }
}

class FinishedPageBody extends StatelessWidget {
  const FinishedPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 30,
      children: [
        const Text(
          "Operation Completed Successfully",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Text(
          "Files saved at /sdcard/Downloads",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
