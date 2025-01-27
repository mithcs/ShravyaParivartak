import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';

import 'finished_page.dart';
import 'utils.dart';

/// Enum representing metadata handling options
/// - [preserve]: Preserve all the existing metadata
/// - [delete]: Removes all metadata
enum Metadata { preserve, delete }

// TODO: Add more audio channels
/// Enum representing available audio channel options
/// - [unchanged]: Keep the audio channel as it is
/// - [mono]: Convert the audio to mono
/// - [stereo]: Convert the audio to stereo
enum AudioChannel { unchanged, mono, stereo }

int _samplingRate = -1;
String _format = 'mp3';
AudioChannel _audioChannel = AudioChannel.unchanged;
Metadata _metadata = Metadata.preserve;

/// Conversion page
class ConversionPage extends StatelessWidget {
  const ConversionPage(
      {super.key, required this.files, required this.filesCount}
  );
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
      {super.key, required this.files, required this.filesCount}
  );

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

      // Audio Channel
      if (_audioChannel == AudioChannel.mono) {
        outputs.add('-ac');
        outputs.add('1');
      } else if (_audioChannel == AudioChannel.stereo) {
        outputs.add('-ac');
        outputs.add('2');
      }

      // Sampling Rate
      if (_samplingRate != -1) {
        outputs.add('-ar');
        outputs.add(_samplingRate.toString());
      }

      // Map files
      outputs.add('-map');
      outputs.add(i.toString());
      outputs.add('$outputPath.$_format');

      // Metadata Option
      if (_metadata == Metadata.preserve) {
        outputs.add('-map_metadata');
        outputs.add(i.toString());
      } else if (_metadata == Metadata.delete) {
        outputs.add('-map_metadata');
        outputs.add('-1');
      }

      // TODO: Fix album art related issue
      // Workound to eliminate failure on copying multiple files with one(or more)
      // file(s) having album art
      outputs.add('-vn');
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

/// Parent class for conversion options
class ConversionOptions extends StatelessWidget {
  const ConversionOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionTitle(title: 'General Options'),
        const FormatDropdown(),
        const SamplingRateDropdown(),
        const SectionTitle(title: 'Metadata'),
        const MetadataRadioButton(),
        const SectionTitle(title: 'Audio Channel'),
        const AudioChannelRadioButton(),
      ],
    );
  }
}

/// Title to categorize options
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )));
  }
}

/// Dropdown to select output format
class FormatDropdown extends StatefulWidget {
  const FormatDropdown({super.key});

  @override
  State<StatefulWidget> createState() => _FormatDropdownState();
}

/// [STATE] Dropdown to select output format
class _FormatDropdownState extends State<FormatDropdown> {
  final formats = [
    'aac',
    'ac3',
    'adts',
    'aif',
    'aifc',
    'au',
    'caf',
    'flac',
    'm4a',
    'mp2',
    'mp3',
    'ogg',
    'opus',
    'ra',
    'tta',
    'wav',
    'wma',
    'wv'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 36,
        children: [
          Text('Output Format', style: TextStyle(fontSize: 18)),
          DropdownButton(
            value: _format,
            elevation: 16,
            underline: Container(
                height: 2, color: Theme.of(context).colorScheme.primary),
            onChanged: (String? value) {
              setState(() {
                _format = value!;
              });
            },
            items: formats.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(' $value'.toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Radiobutton to decide whether to preserve or delete metadata
class MetadataRadioButton extends StatefulWidget {
  const MetadataRadioButton({super.key});

  @override
  State<MetadataRadioButton> createState() => _MetadataRadioButtonState();
}

/// [STATE] Radiobutton to decide whether to preserve or delete metadata
class _MetadataRadioButtonState extends State<MetadataRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile(
          title: Text('Preserve Metadata'),
          value: Metadata.preserve,
          groupValue: _metadata,
          onChanged: (Metadata? value) {
            setState(() {
              _metadata = value!;
            });
          },
        ),
        RadioListTile(
          title: Text('Delete Metadata'),
          value: Metadata.delete,
          groupValue: _metadata,
          onChanged: (Metadata? value) {
            setState(() {
              _metadata = value!;
            });
          },
        ),
      ],
    );
  }
}

/// Radiobutton to decide audio channel: Default/Mono/Stereo
class AudioChannelRadioButton extends StatefulWidget {
  const AudioChannelRadioButton({super.key});

  @override
  State<AudioChannelRadioButton> createState() => _AudioChannelRadioButtonState();
}

/// [STATE] Radiobutton to decide audio channel: Default/Mono/Stereo
class _AudioChannelRadioButtonState extends State<AudioChannelRadioButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: AudioChannel.unchanged,
              groupValue: _audioChannel,
              onChanged: (AudioChannel? value) {
                setState(() {
                  _audioChannel = value!;
                });
              },
            ),
            Text('Unchanged', style: TextStyle(fontSize: 18)),
            Radio(
              value: AudioChannel.mono,
              groupValue: _audioChannel,
              onChanged: (AudioChannel? value) {
                setState(() {
                  _audioChannel = value!;
                });
              },
            ),
            Text('Mono', style: TextStyle(fontSize: 18)),
            Radio(
              value: AudioChannel.stereo,
              groupValue: _audioChannel,
              onChanged: (AudioChannel? value) {
                setState(() {
                  _audioChannel = value!;
                });
              },
            ),
            Text('Stereo', style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }
}

/// Dropdown to select sampling rate
class SamplingRateDropdown extends StatefulWidget {
  const SamplingRateDropdown({super.key});

  @override
  State<StatefulWidget> createState() => _SamplingRateDropDownState();
}

class _SamplingRateDropDownState extends State<SamplingRateDropdown> {
  /// Set of commonly used audio sampling rates (in Hz)
  final Set<int> samplingRates = {
    -1,
    8000,
    16000,
    22000,
    32000,
    44100,
    48000,
    64000,
    88200,
    96000,
    128000,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 36,
        children: [
          Text('Sampling Rate', style: TextStyle(fontSize: 18)),
          DropdownButton(
            value: _samplingRate,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (int? value) {
              setState(() {
                _samplingRate = value!;
              });
            },
            items: samplingRates.map((int value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value == -1 ? ' Unchanged' : ' ${value / 1000}k'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
