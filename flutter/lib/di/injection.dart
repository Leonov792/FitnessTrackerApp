import 'package:fitness_tracker/data/datasources/workout_local_data_source.dart';
import 'package:fitness_tracker/data/datasources/workout_remote_data_source.dart';
import 'package:fitness_tracker/data/models/workout_model.dart';
import 'package:fitness_tracker/data/repositories/workout_repository_impl.dart';
import 'package:fitness_tracker/domain/repositories/workout_repository.dart';
import 'package:fitness_tracker/domain/use_cases/add_workout.dart';
import 'package:fitness_tracker/domain/use_cases/get_workouts.dart';
import 'package:fitness_tracker/presentation/cubit/tracker_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final GetIt getIt = GetIt.instance;

/// Wires the dependency graph (Hive, Dio, repository, use cases, cubit).
Future<void> setupDependencies() async {
  final box = await Hive.openBox<WorkoutModel>('workouts');

  getIt
    ..registerSingleton<Box<WorkoutModel>>(box)
    ..registerLazySingleton<WorkoutLocalDataSource>(
      () => WorkoutLocalDataSource(getIt<Box<WorkoutModel>>()),
    )
    // Swap MockRemoteWorkoutApi for DioRemoteWorkoutApi once the backend exists.
    ..registerLazySingleton<RemoteWorkoutApi>(MockRemoteWorkoutApi.new)
    ..registerLazySingleton<WorkoutRepository>(
      () => WorkoutRepositoryImpl(
        local: getIt<WorkoutLocalDataSource>(),
        remote: getIt<RemoteWorkoutApi>(),
      ),
    )
    ..registerLazySingleton<AddWorkout>(
      () => AddWorkout(getIt<WorkoutRepository>()),
    )
    ..registerLazySingleton<GetWorkouts>(
      () => GetWorkouts(getIt<WorkoutRepository>()),
    )
    ..registerFactory<TrackerCubit>(
      () => TrackerCubit(
        addWorkout: getIt<AddWorkout>(),
        getWorkouts: getIt<GetWorkouts>(),
      ),
    );
}
