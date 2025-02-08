import 'package:flutter/material.dart';

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
            )));    // blame lsp for this formatting
  }
}

