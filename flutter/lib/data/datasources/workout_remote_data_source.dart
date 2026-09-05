import 'package:dio/dio.dart';
import 'package:fitness_tracker/data/models/workout_model.dart';

/// Remote API for syncing workouts (task-tracker backend).
abstract class RemoteWorkoutApi {
  Future<List<WorkoutModel>> fetchWorkouts();

  Future<void> syncWorkout(WorkoutModel workout);
}

/// Real HTTP implementation using Dio.
class DioRemoteWorkoutApi implements RemoteWorkoutApi {
  DioRemoteWorkoutApi({required Dio dio, required String baseUrl})
    : _dio = dio,
      _baseUrl = baseUrl;

  final Dio _dio;
  final String _baseUrl;

  @override
  Future<List<WorkoutModel>> fetchWorkouts() async {
    final response = await _dio.get<List<dynamic>>('$_baseUrl/workouts');
    final data = response.data ?? const <dynamic>[];
    return data
        .map((json) => WorkoutModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> syncWorkout(WorkoutModel workout) async {
    await _dio.post<void>('$_baseUrl/workouts', data: workout.toJson());
  }
}

/// Mock implementation used until the real backend is available.
class MockRemoteWorkoutApi implements RemoteWorkoutApi {
  const MockRemoteWorkoutApi();

  @override
  Future<List<WorkoutModel>> fetchWorkouts() async => const <WorkoutModel>[];

  @override
  Future<void> syncWorkout(WorkoutModel workout) async {}
}
