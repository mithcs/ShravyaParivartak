import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../others/finished_page.dart';
import '../others/shared.dart';
import '../others/utils.dart';
import 'audiochannel_options.dart';
import 'definitions.dart';
import 'general_options.dart';
import 'metadata_options.dart';

/// Parent class for conversion options
class ConversionOptions extends StatelessWidget {
  const ConversionOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionTitle(title: 'General Options'),
        const FormatSelection(),
        const SamplingRateSelection(),
        const SectionTitle(title: 'Metadata'),
        const MetadataSelection(),
        const SectionTitle(title: 'Audio Channel'),
        const AudioChannelRadioButton(),
      ],
    );
  }
}

/// Function to do the actual conversion of files
void convertFiles(BuildContext context, int filesCount,
    List<PlatformFile> files, String outputDir) async {
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
    if (audioChannel == AudioChannel.mono) {
      outputs.add('-ac');
      outputs.add('1');
    } else if (audioChannel == AudioChannel.stereo) {
      outputs.add('-ac');
      outputs.add('2');
    }

    // Sampling Rate
    if (samplingRate != -1) {
      outputs.add('-ar');
      outputs.add(samplingRate.toString());
    }

    // Map files
    outputs.add('-map');
    outputs.add(i.toString());
    outputs.add('$outputPath.$format');

    // Metadata Option
    if (metadata == Metadata.preserve) {
      outputs.add('-map_metadata');
      outputs.add(i.toString());
    } else if (metadata == Metadata.delete) {
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
