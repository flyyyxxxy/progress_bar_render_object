import 'package:flutter/material.dart';
import 'package:progress_bar_by_ro/progress_bar_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 500,
            child: ProgressBar(
              dotColor: Colors.blue,
              thumbColor: Colors.blue,
              thumbSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
