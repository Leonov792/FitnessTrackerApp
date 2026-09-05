import 'package:fitness_tracker/data/models/workout_model.dart';
import 'package:hive/hive.dart';

/// Local persistence backed by a Hive box.
class WorkoutLocalDataSource {
  const WorkoutLocalDataSource(this._box);

  final Box<WorkoutModel> _box;

  List<WorkoutModel> getAll() {
    final workouts = _box.values.toList();
    workouts.sort((a, b) => b.date.compareTo(a.date));
    return workouts;
  }

  int nextId() {
    if (_box.isEmpty) {
      return 1;
    }
    return _box.values
            .map((workout) => workout.id)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }

  Future<void> add(WorkoutModel workout) => _box.add(workout);

  Stream<List<WorkoutModel>> watch() {
    return _box.watch().map((event) => getAll());
  }
}
