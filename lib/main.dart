import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String title = 'Audio Converter';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return MaterialApp(
      title: title,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        scaffoldBackgroundColor: theme.primaryContainer,

        appBarTheme: AppBarTheme(
          backgroundColor: theme.primary,
          foregroundColor: theme.onPrimary,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(theme.onPrimary),
            backgroundColor: WidgetStateProperty.all(theme.primary),
          ),
        ),
      ),
      home: SelectFilesPage(),
    );
  }
}

class SelectFilesPage extends StatelessWidget {
  const SelectFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Files'),
      ),
      body: SelectFilesBody(),
    );
  }
}

class SelectFilesBody extends StatelessWidget {
  SelectFilesBody({super.key});

  late final PlatformFile file;

  void _selectFiles(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (!context.mounted) return;

    if (result == null) return;
    file = result.files.first;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return ConversionPage( file: file);
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

class ConversionBody extends StatelessWidget {
  const ConversionBody({super.key, required this.file});

  final PlatformFile file;
  final String outputDir = '/sdcard/Download/';

  String? get inputPath => file.path;
  int get lastDotPos => file.name.lastIndexOf('.');
  String? get outputPath => outputDir + file.name.substring(0, lastDotPos);

  void _convertFiles() {
    FFmpegKit.execute('-i $inputPath $outputPath.wav').then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        // SUCCESS
      } else if (ReturnCode.isCancel(returnCode)) {
        // CANCEL
      } else {
        // ERROR
      }
    });
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
                onPressed: _convertFiles,
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
