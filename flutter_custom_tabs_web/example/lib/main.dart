import 'package:flutter/material.dart';

void main() => runApp(const TestApp());

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Text('Now testing...'),
    );
  }
}
