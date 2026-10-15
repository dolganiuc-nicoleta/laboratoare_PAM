import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const GemStoreApp());

class GemStoreApp extends StatelessWidget {
  const GemStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GemStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F5F3),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}