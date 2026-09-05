import 'package:fitness_tracker/domain/repositories/workout_repository.dart';

/// Adds a new workout to the repository.
class AddWorkout {
  const AddWorkout(this._repository);

  final WorkoutRepository _repository;

  Future<void> call({required int steps, required int durationMinutes}) {
    return _repository.addWorkout(
      steps: steps,
      durationMinutes: durationMinutes,
    );
  }
}
