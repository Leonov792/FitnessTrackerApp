import 'package:equatable/equatable.dart';
import 'package:fitness_tracker/domain/entities/workout.dart';

/// UI state for the tracker screen.
class TrackerState extends Equatable {
  const TrackerState._({
    required this.workouts,
    required this.errorMessage,
    required this.isLoading,
  });

  const TrackerState.initial()
    : this._(workouts: const [], errorMessage: null, isLoading: true);

  const TrackerState.loaded(List<Workout> workouts)
    : this._(workouts: workouts, errorMessage: null, isLoading: false);

  const TrackerState.error(String message)
    : this._(workouts: const [], errorMessage: message, isLoading: false);

  final List<Workout> workouts;
  final String? errorMessage;
  final bool isLoading;

  int get totalSteps => workouts.fold(0, (sum, workout) => sum + workout.steps);

  int get totalCalories => Workout.caloriesFor(totalSteps);

  double get totalDistanceKm => Workout.distanceKmFor(totalSteps);

  @override
  List<Object?> get props => [workouts, errorMessage, isLoading];
}
