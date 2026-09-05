import 'package:fitness_tracker/domain/entities/workout.dart';

/// Abstraction over workout persistence and sync.
abstract class WorkoutRepository {
  /// Emits the current list of workouts (newest first) and updates on change.
  Stream<List<Workout>> watchWorkouts();

  /// Records a new workout with the given steps and duration.
  Future<void> addWorkout({required int steps, required int durationMinutes});
}
