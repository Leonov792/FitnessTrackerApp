import 'dart:async';

import 'package:fitness_tracker/data/datasources/workout_local_data_source.dart';
import 'package:fitness_tracker/data/datasources/workout_remote_data_source.dart';
import 'package:fitness_tracker/data/models/workout_model.dart';
import 'package:fitness_tracker/data/repositories/workout_repository_impl.dart';
import 'package:fitness_tracker/domain/entities/workout.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocal extends Mock implements WorkoutLocalDataSource {}

class MockRemote extends Mock implements RemoteWorkoutApi {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      WorkoutModel(
        id: 0,
        steps: 0,
        calories: 0,
        durationMinutes: 0,
        date: DateTime(2024),
      ),
    );
  });

  late MockLocal local;
  late MockRemote remote;
  late WorkoutRepositoryImpl repository;

  setUp(() {
    local = MockLocal();
    remote = MockRemote();
    repository = WorkoutRepositoryImpl(local: local, remote: remote);
  });

  test(
    'addWorkout computes calories and persists locally then syncs',
    () async {
      when(() => local.nextId()).thenReturn(1);
      when(() => local.add(any())).thenAnswer((_) async {});
      when(() => remote.syncWorkout(any())).thenAnswer((_) async {});

      await repository.addWorkout(steps: 100, durationMinutes: 30);

      final captured = verify(() => local.add(captureAny())).captured.single;
      final model = captured as WorkoutModel;
      expect(model.steps, 100);
      expect(model.calories, Workout.caloriesFor(100));
      expect(model.durationMinutes, 30);
      verify(() => remote.syncWorkout(any())).called(1);
    },
  );

  test('watchWorkouts maps models to entities', () async {
    final controller = StreamController<List<WorkoutModel>>();
    when(() => local.watch()).thenAnswer((_) => controller.stream);

    final workout = WorkoutModel(
      id: 1,
      steps: 100,
      calories: 4,
      durationMinutes: 30,
      date: DateTime(2024),
    );
    final future = repository.watchWorkouts().first;
    controller.add([workout]);

    final result = await future;
    expect(result.single, isA<Workout>());
    expect(result.single.steps, 100);
    await controller.close();
  });
}
