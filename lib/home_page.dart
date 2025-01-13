import 'conversion_page.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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

class HomePageBody extends StatelessWidget {
  HomePageBody({super.key});

  late final PlatformFile file;

  void _selectFiles(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (!context.mounted) return;

    if (result == null) return;
    file = result.files.first;

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
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w300,
            ),
          ),
          ElevatedButton(
            onPressed: () => _selectFiles(context),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Select',
                style: TextStyle(
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

