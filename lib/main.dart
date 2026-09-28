import 'package:flutter/material.dart';
import 'pages/cuidadores_page.dart';

void main() {
  runApp(const AmigoPetApp());
}

class AmigoPetApp extends StatelessWidget {
  const AmigoPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AmigoPet',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF4CAF50),
      ),
      home: const CuidadoresPage(),
    );
  }
}