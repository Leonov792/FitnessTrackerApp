import 'package:fitness_tracker/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A84FF)),
      ),
      home: const HomePage(),
    );
  }
}
