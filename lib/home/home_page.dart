import 'package:flutter/material.dart';

import 'select_files.dart';

/// Home page of the application
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Files'),
      ),
      body: HomePageBody(),
    );
  }
}

/// Body of home page
class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 40,
        children: [
          SelectText(),
          SelectButton(),
        ],
      ),
    );
  }
}
