import 'package:flutter/material.dart';

void main() {
  runApp(const HestiaApp());
}

class HestiaApp extends StatelessWidget {
  const HestiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Hestia',
      home: Scaffold(
        body: Center(
          child: Text('Hestia'),
        ),
      ),
    );
  }
}
