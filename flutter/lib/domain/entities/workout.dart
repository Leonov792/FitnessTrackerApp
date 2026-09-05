import 'package:equatable/equatable.dart';

/// A single recorded workout session.
class Workout extends Equatable {
  const Workout({
    required this.id,
    required this.steps,
    required this.calories,
    required this.durationMinutes,
    required this.date,
  });

  /// Calories burned per step.
  static const double caloriesPerStep = 0.04;

  /// Kilometers walked per step.
  static const double kmPerStep = 0.0008;

  final int id;
  final int steps;
  final int calories;
  final int durationMinutes;
  final DateTime date;

  /// Calories derived from a step count (domain rule).
  static int caloriesFor(int steps) => (steps * caloriesPerStep).round();

  /// Distance in kilometers derived from a step count (domain rule).
  static double distanceKmFor(int steps) => steps * kmPerStep;

  @override
  List<Object?> get props => [id, steps, calories, durationMinutes, date];
}
