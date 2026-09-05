import 'package:fitness_tracker/domain/entities/workout.dart';
import 'package:fitness_tracker/domain/repositories/workout_repository.dart';

/// Observes the list of workouts.
class GetWorkouts {
  const GetWorkouts(this._repository);

  final WorkoutRepository _repository;

  Stream<List<Workout>> call() => _repository.watchWorkouts();
}
