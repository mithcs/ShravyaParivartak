import 'package:flutter/material.dart';

import 'definitions.dart';

/// To select metadata options (preserve / delete)
class MetadataSelection extends StatefulWidget {
  const MetadataSelection({super.key});

  @override
  State<MetadataSelection> createState() => _MetadataSelectionState();
}

/// [STATE] To select metadata options (preserve / delete)
class _MetadataSelectionState extends State<MetadataSelection> {
  Metadata _selectedMetadata = Metadata.preserve; // Shared state

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MetadataRadioButton(
          value: Metadata.preserve,
          groupValue: _selectedMetadata,
          onChanged: (newValue) {
            setState(() {
              _selectedMetadata = newValue!;
            });
          },
        ),
        MetadataRadioButton(
          value: Metadata.delete,
          groupValue: _selectedMetadata,
          onChanged: (newValue) {
            setState(() {
              _selectedMetadata = newValue!;
            });
          },
        ),
      ],
    );
  }
}

/// Radiobutton to decide whether to preserve or delete metadata
class MetadataRadioButton extends StatelessWidget {
  const MetadataRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final Metadata value;
  final Metadata groupValue;
  final ValueChanged<Metadata?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<Metadata>(
      title: Text(
          value == Metadata.preserve ? 'Preserve Metadata' : 'Delete Metadata'),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}

/// Checbox to decide whether to delete album art or not
class AlbumArtSelection extends StatefulWidget {
  const AlbumArtSelection({super.key});

  @override
  State<AlbumArtSelection> createState() => _AlbumArtSelectionState();
}

/// [STATE] Checbox to decide whether to delete album art or not
class _AlbumArtSelectionState extends State<AlbumArtSelection> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text('Delete Album Art'),
      value: deleteAlbumArt,
      onChanged: (bool? newValue) {
        setState(() {
          deleteAlbumArt = newValue!;
        });
      },
    );
  }
}
