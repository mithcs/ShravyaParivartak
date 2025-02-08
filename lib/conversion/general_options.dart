import 'package:flutter/material.dart';

import 'definitions.dart';

final _formats = [
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

final Set<int> _samplingRates = {
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

/// Dropdown to select output format
class FormatSelection extends StatefulWidget {
  const FormatSelection({super.key});

  @override
  State<StatefulWidget> createState() => FormatSelectionState();
}

/// [STATE] Dropdown to select output format
class FormatSelectionState extends State<FormatSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 36,
        children: [
          Text('Output Format', style: TextStyle(fontSize: 18)),
          OutputFormatDropdown(),
        ],
      ),
    );
  }
}

class OutputFormatDropdown extends StatefulWidget {
  const OutputFormatDropdown({super.key});

  @override
  State<OutputFormatDropdown> createState() => _OutputFormatDropdownState();
}

class _OutputFormatDropdownState extends State<OutputFormatDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: format,
      elevation: 16,
      underline:
          Container(height: 2, color: Theme.of(context).colorScheme.primary),
      onChanged: (String? value) {
        setState(() {
          format = value!;
        });
      },
      items: _formats.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(' $value'.toUpperCase()),
        );
      }).toList(),
    );
  }
}

/// Dropdown to select sampling rate
class SamplingRateSelection extends StatefulWidget {
  const SamplingRateSelection({super.key});

  @override
  State<StatefulWidget> createState() => _SamplingRateSelectionState();
}

class _SamplingRateSelectionState extends State<SamplingRateSelection> {
  /// Set of commonly used audio sampling rates (in Hz)
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 36,
        children: [
          Text('Sampling Rate', style: TextStyle(fontSize: 18)),
          SamplingRateDropdown(),
        ],
      ),
    );
  }
}

class SamplingRateDropdown extends StatefulWidget {
  const SamplingRateDropdown({super.key});

  @override
  State<SamplingRateDropdown> createState() => _SamplingRateDropdownState();
}

class _SamplingRateDropdownState extends State<SamplingRateDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: samplingRate,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(context).colorScheme.primary,
      ),
      onChanged: (int? value) {
        setState(() {
          samplingRate = value!;
        });
      },
      items: _samplingRates.map((int value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value == -1 ? ' Unchanged' : ' ${value / 1000}k'),
        );
      }).toList(),
    );
  }
}
