import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

import 'finished_page.dart';
import 'utils.dart';

/// Conversion page
class ConversionPage extends StatelessWidget {
  const ConversionPage({super.key, required this.file});
  final PlatformFile file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convert Files'),
      ),
      body: ConversionBody(file: file),
    );
  }
}

/// Body of conversion page
class ConversionBody extends StatelessWidget {
  const ConversionBody({super.key, required this.file});

  final PlatformFile file;
  final String outputDir = '/sdcard/Download/';

  String? get inputPath => file.path;
  int get lastDotPos => file.name.lastIndexOf('.');
  String? get outputPath => outputDir + file.name.substring(0, lastDotPos);

  void _convertFiles(BuildContext context) {
    // Execute ffmpeg command
    FFmpegKit.execute('-i $inputPath $outputPath.wav').then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        // SUCCESS
        // ...
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
        // ...
      } else {
        // ERROR
        // ...
      }
    });

    // Route to next page
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return FinishedPage();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 40,
      children: [
        Placeholder(),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => _convertFiles(context),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
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
        ),
      ],
    );
  }
}
