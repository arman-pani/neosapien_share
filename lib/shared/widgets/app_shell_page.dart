import 'package:flutter/material.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Semantics(label: title, child: const SizedBox.expand()),
      ),
    );
  }
}
