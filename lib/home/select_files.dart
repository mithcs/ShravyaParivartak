import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../others/utils.dart';
import '../conversion/conversion_page.dart';

// Handles file selection and routing
Future<void> _handleFileSelection(BuildContext context) async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: true);

  if (!context.mounted) return;

  // When file is not selected
  if (result == null) {
    Utilities.showSnackBar(context, 'Try Again!');
    return;
  }

  List<PlatformFile> files = result.files;
  int filesCount = result.files.length;

  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) {
      return ConversionPage(files: files, filesCount: filesCount);
    }),
  );
}

/// Text to accompany select button
class SelectText extends StatelessWidget {
  const SelectText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Select files to convert',
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

/// Button for selecting files
class SelectButton extends StatelessWidget {
  const SelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleFileSelection(context),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          'Select',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
