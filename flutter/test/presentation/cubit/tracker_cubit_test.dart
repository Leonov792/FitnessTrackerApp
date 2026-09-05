import 'dart:async';

import 'package:fitness_tracker/domain/entities/workout.dart';
import 'package:fitness_tracker/domain/repositories/workout_repository.dart';
import 'package:fitness_tracker/domain/use_cases/add_workout.dart';
import 'package:fitness_tracker/domain/use_cases/get_workouts.dart';
import 'package:fitness_tracker/presentation/cubit/tracker_cubit.dart';
import 'package:fitness_tracker/presentation/cubit/tracker_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutRepository extends Mock implements WorkoutRepository {}

void main() {
  late MockWorkoutRepository repository;
  late StreamController<List<Workout>> controller;
  late TrackerCubit cubit;

  setUp(() {
    repository = MockWorkoutRepository();
    controller = StreamController<List<Workout>>();
    when(() => repository.watchWorkouts()).thenAnswer((_) => controller.stream);
    when(
      () => repository.addWorkout(
        steps: any<int>(named: 'steps'),
        durationMinutes: any<int>(named: 'durationMinutes'),
      ),
    ).thenAnswer((_) async {});
    cubit = TrackerCubit(
      addWorkout: AddWorkout(repository),
      getWorkouts: GetWorkouts(repository),
    );
  });

  tearDown(() async {
    await cubit.close();
    await controller.close();
  });

  test('addWorkout records a workout via the repository', () async {
    await cubit.addWorkout(steps: 200, durationMinutes: 45);

    verify(() => repository.addWorkout(steps: 200, durationMinutes: 45))
        .called(1);
  });

  test('emits loaded state with totals when the stream emits', () async {
    final states = <TrackerState>[];
    final subscription = cubit.stream.listen(states.add);

    controller.add([
      Workout(
        id: 1,
        steps: 200,
        calories: 8,
        durationMinutes: 30,
        date: DateTime(2024),
      ),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(states.last.isLoading, isFalse);
    expect(states.last.totalSteps, 200);
    expect(states.last.totalCalories, Workout.caloriesFor(200));
    await subscription.cancel();
  });
}
