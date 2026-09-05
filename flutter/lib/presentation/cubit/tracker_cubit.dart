import 'dart:async';

import 'package:fitness_tracker/domain/entities/workout.dart';
import 'package:fitness_tracker/domain/use_cases/add_workout.dart';
import 'package:fitness_tracker/domain/use_cases/get_workouts.dart';
import 'package:fitness_tracker/presentation/cubit/tracker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Drives the tracker screen: observes workouts and records new ones.
class TrackerCubit extends Cubit<TrackerState> {
  TrackerCubit({
    required AddWorkout addWorkout,
    required GetWorkouts getWorkouts,
  }) : _addWorkout = addWorkout,
       _getWorkouts = getWorkouts,
       super(const TrackerState.initial()) {
    _subscribe();
  }

  final AddWorkout _addWorkout;
  final GetWorkouts _getWorkouts;
  StreamSubscription<List<Workout>>? _subscription;

  void _subscribe() {
    _subscription = _getWorkouts().listen(
      (workouts) => emit(TrackerState.loaded(workouts)),
      onError: (Object error, StackTrace stackTrace) {
        emit(TrackerState.error(error.toString()));
      },
    );
  }

  Future<void> addWorkout({
    required int steps,
    required int durationMinutes,
  }) async {
    await _addWorkout(steps: steps, durationMinutes: durationMinutes);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
