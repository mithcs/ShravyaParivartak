import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'convert.dart';

/// Conversion page
class ConversionPage extends StatelessWidget {
  const ConversionPage(
      {super.key, required this.files, required this.filesCount});
  final List<PlatformFile> files;
  final int filesCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convert Files'),
      ),
      body: ConversionBody(files: files, filesCount: filesCount),
    );
  }
}

/// Body of conversion page
class ConversionBody extends StatelessWidget {
  const ConversionBody(
      {super.key, required this.files, required this.filesCount});

  final List<PlatformFile> files;
  final int filesCount;
  final String outputDir = '/sdcard/Download/';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 40,
      children: [
        ConversionOptions(),
        ConvertButton(filesCount: filesCount, files: files, outputDir: outputDir),
      ],
    );
  }
}

/// Convert button
class ConvertButton extends StatelessWidget {
  const ConvertButton({
    super.key,
    required this.filesCount,
    required this.files,
    required this.outputDir,
  });

  final int filesCount;
  final List<PlatformFile> files;
  final String outputDir;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => convertFiles(context, filesCount, files, outputDir),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Convert',
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

