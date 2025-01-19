import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shravya_parivartak/utils.dart';

import 'conversion_page.dart';

/// Home page of the application
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Files'),
      ),
      body: HomePageBody(),
    );
  }
}

/// Body of home page
class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  // Handles file selection and routing
  Future<void> _handleFileSelection(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    // Check if widget is still mounted
    if (!context.mounted) return;

    // When file is not selected
    if (result == null) {
      Utilities.showSnackBar(context, 'Try Again');
      return;
    }

    // Get the first file
    PlatformFile file = result.files.first;

    // Route to next page
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return ConversionPage(file: file);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          Text(
            'Select files to convert',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w300,
            ),
          ),
          ElevatedButton(
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
          ),
        ],
      ),
    );
  }
}

