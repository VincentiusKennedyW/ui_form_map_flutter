import 'package:flutter/material.dart';
import 'package:relawan_pemilu_ui/task%201/form_keluarga_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FormKeluarga(),
    );
  }
}
