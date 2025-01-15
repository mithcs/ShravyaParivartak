import 'package:flutter/material.dart';

void main() => runApp(const MyApp(title: 'Audio Converter'));

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.title});

  final String title;

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
      home: SelectFilesPage(title: 'Select Files'),
    );
  }
}

class SelectFilesPage extends StatelessWidget {
  const SelectFilesPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SelectFilesBody(),
    );
  }
}

class SelectFilesBody extends StatelessWidget {
  const SelectFilesBody({super.key});

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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return ConversionPage(title: 'Convert Files');
                }),
              );
            },
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
  const ConversionPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ConversionBody(),
    );
  }
}

class ConversionBody extends StatelessWidget {
  const ConversionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
