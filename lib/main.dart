import 'package:flutter/material.dart';
import 'package:phantomsolutions/splash.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phantom Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.lightGreen,
      ),
      home: const SplashScreen(),
    );
  }
}
