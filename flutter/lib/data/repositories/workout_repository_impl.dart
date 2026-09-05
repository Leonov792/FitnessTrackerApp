import 'package:fitness_tracker/data/datasources/workout_local_data_source.dart';
import 'package:fitness_tracker/data/datasources/workout_remote_data_source.dart';
import 'package:fitness_tracker/data/models/workout_model.dart';
import 'package:fitness_tracker/domain/entities/workout.dart';
import 'package:fitness_tracker/domain/repositories/workout_repository.dart';

/// Local-first repository: reads from Hive and best-effort syncs to the remote.
class WorkoutRepositoryImpl implements WorkoutRepository {
  WorkoutRepositoryImpl({
    required WorkoutLocalDataSource local,
    required RemoteWorkoutApi remote,
  }) : _local = local,
       _remote = remote;

  final WorkoutLocalDataSource _local;
  final RemoteWorkoutApi _remote;

  @override
  Stream<List<Workout>> watchWorkouts() {
    return _local.watch().map(
      (models) => models.map((model) => model.toEntity()).toList(),
    );
  }

  @override
  Future<void> addWorkout({
    required int steps,
    required int durationMinutes,
  }) async {
    final workout = WorkoutModel(
      id: _local.nextId(),
      steps: steps,
      calories: Workout.caloriesFor(steps),
      durationMinutes: durationMinutes,
      date: DateTime.now(),
    );
    await _local.add(workout);
    await _remote.syncWorkout(workout);
  }
}
