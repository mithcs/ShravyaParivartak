import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';

import 'finished_page.dart';
import 'utils.dart';

String format = 'mp3';
bool preserveMetadata = false;

/// Conversion page
class ConversionPage extends StatelessWidget {
  const ConversionPage({super.key, required this.files, required this.filesCount});
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
  const ConversionBody({super.key, required this.files, required this.filesCount});

  final List<PlatformFile> files;
  final int filesCount;
  final String outputDir = '/sdcard/Download/';

  void _convertFiles(BuildContext context) async {
    Utilities.showProcessingDialog(context);

    List<String> cmd = [];
    List<String> inputs = [];
    List<String> outputs = [];

    for (int i = 0; i < filesCount; ++i) {
      int lastDotPos = files[i].name.lastIndexOf('.');
      String outputPath = outputDir + files[i].name.substring(0, lastDotPos);

      inputs.add('-i');
      inputs.add(files[i].path!);

      if (preserveMetadata) {
        outputs.add('-map_metadata');
        outputs.add(i.toString());
      }

      outputs.add('-map');
      outputs.add(i.toString());
      outputs.add('$outputPath.$format');
    }

    cmd.addAll(inputs);
    cmd.addAll(outputs);

    FFmpegKit.executeWithArgumentsAsync(cmd, (session) async {
      final returnCode = await session.getReturnCode();
      if (!context.mounted) return;

      Navigator.of(context).pop();

      // Verify return code
      if (ReturnCode.isSuccess(returnCode)) {
        // Route to next page
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return FinishedPage();
          }),
        );
      } else if (ReturnCode.isCancel(returnCode)) {
        Utilities.showSnackBar(context, 'Operation Cancelled!');
      } else {
        Utilities.showSnackBar(context, 'Operation Failed!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 40,
      children: [
        ConversionOptions(),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => _convertFiles(context),
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
        ),
      ],
    );
  }
}

class ConversionOptions extends StatelessWidget {
  const ConversionOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FormatDropdown(),
        const MetadataCheckbox(),
        const Placeholder(),
      ],
    );
  }
}

class FormatDropdown extends StatefulWidget {
  const FormatDropdown({super.key});

  @override
  State<StatefulWidget> createState() => _FormatDropdownState();
}

class _FormatDropdownState extends State<FormatDropdown> {
  final formats = ['aac', 'ac3', 'adts', 'aif', 'aifc', 'au', 'caf', 'flac', 'm4a', 'mp2', 'mp3', 'ogg', 'opus', 'ra', 'tta', 'wav', 'wma', 'wv'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: format,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(context).colorScheme.primary
      ),
      onChanged: (String? value) {
        setState(() {
          format = value!;
        });
      },
      items: formats.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(' ' + value.toUpperCase()),
        );
      }).toList(),
    );
  }
}

class MetadataCheckbox extends StatefulWidget {
  const MetadataCheckbox({super.key});

  @override
  State<MetadataCheckbox> createState() => _MetadataCheckboxState();
}

class _MetadataCheckboxState extends State<MetadataCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Preserve Metadata'),
      value: preserveMetadata,
      onChanged: (bool? value) {
        setState(() {
          preserveMetadata = value!;
        });
      },
    );
  }
}
