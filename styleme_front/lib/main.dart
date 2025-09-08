import 'package:flutter/material.dart';

void main() {
  runApp(const StyleMeApp());
}

class StyleMeApp extends StatelessWidget {
  const StyleMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StyleMe',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('¡Bienvenido a StyleMe!')),
      ),
    );
  }
}