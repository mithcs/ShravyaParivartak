import 'package:flutter/material.dart';

import 'definitions.dart';

/// Radiobutton to decide whether to preserve or delete metadata
class MetadataSelection extends StatefulWidget {
  const MetadataSelection({super.key});

  @override
  State<MetadataSelection> createState() => _MetadataSelectionState();
}

/// [STATE] Radiobutton to decide whether to preserve or delete metadata
class _MetadataSelectionState extends State<MetadataSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MetadataRadioButton(value: Metadata.preserve),
        MetadataRadioButton(value: Metadata.delete),
      ],
    );
  }
}

class MetadataRadioButton extends StatefulWidget {
  const MetadataRadioButton({super.key, required this.value});
  final Metadata value;

  @override
  State<MetadataRadioButton> createState() => _MetadataRadioButtonState();
}

class _MetadataRadioButtonState extends State<MetadataRadioButton> {
  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text('Preserve Metadata'),
      value: widget.value,
      groupValue: metadata,
      onChanged: (Metadata? newValue) {
        setState(() {
          metadata = newValue!;
        });
      },
    );
  }
}
