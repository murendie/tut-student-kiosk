import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUT Kiosk',
      theme: ThemeData(
        fontFamily: 'Ruda',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005496),
          primary: const Color(0xFF005496),
          secondary: const Color(0xFFE41936),
          tertiary: const Color(0xFFF9BC0A),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
