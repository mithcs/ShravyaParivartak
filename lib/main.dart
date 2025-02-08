import 'package:flutter/material.dart';

import 'home/home_page.dart';

/// Entry point of app
void main() => runApp(const MyApp());

/// Main application class
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
      home: HomePage(),
    );
  }
}

