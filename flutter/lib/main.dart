import 'package:fitness_tracker/app.dart';
import 'package:fitness_tracker/data/models/workout_model.dart';
import 'package:fitness_tracker/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutModelAdapter());
  await setupDependencies();
  runApp(const FitnessTrackerApp());
}
