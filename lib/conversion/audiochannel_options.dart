import 'package:flutter/material.dart';

import 'definitions.dart';

/// Radiobutton to decide audio channel: Default/Mono/Stereo
class AudioChannelRadioButton extends StatefulWidget {
  const AudioChannelRadioButton({super.key});

  @override
  State<AudioChannelRadioButton> createState() =>
      _AudioChannelRadioButtonState();
}

/// [STATE] Radiobutton to decide audio channel: Default/Mono/Stereo
class _AudioChannelRadioButtonState extends State<AudioChannelRadioButton> {
  Widget _buildRadioButton(AudioChannel value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: value,
          groupValue: audioChannel,
          onChanged: (AudioChannel? newValue) {
            setState(() {
              audioChannel = newValue!;
            });
          },
        ),
        Text(label, style: TextStyle(fontSize: 18)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRadioButton(AudioChannel.unchanged, 'Unchanged'),
        _buildRadioButton(AudioChannel.mono, 'Mono'),
        _buildRadioButton(AudioChannel.stereo, 'Stereo'),
      ],
    );
  }
}
