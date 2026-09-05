import 'package:fitness_tracker/di/injection.dart';
import 'package:fitness_tracker/presentation/cubit/tracker_cubit.dart';
import 'package:fitness_tracker/presentation/cubit/tracker_state.dart';
import 'package:fitness_tracker/presentation/widgets/add_workout_dialog.dart';
import 'package:fitness_tracker/presentation/widgets/stats_header.dart';
import 'package:fitness_tracker/presentation/widgets/workout_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrackerCubit>(
      create: (_) => getIt<TrackerCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  Future<void> _addWorkout(BuildContext context) async {
    final result = await showDialog<AddWorkoutResult>(
      context: context,
      builder: (dialogContext) => const AddWorkoutDialog(),
    );
    if (result == null || !context.mounted) {
      return;
    }
    await context.read<TrackerCubit>().addWorkout(
      steps: result.steps,
      durationMinutes: result.minutes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Tracker')),
      body: BlocBuilder<TrackerCubit, TrackerState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          return Column(
            children: [
              StatsHeader(
                steps: state.totalSteps,
                calories: state.totalCalories,
                distanceKm: state.totalDistanceKm,
              ),
              Expanded(
                child: state.workouts.isEmpty
                    ? const Center(child: Text('No workouts yet'))
                    : ListView.builder(
                        itemCount: state.workouts.length,
                        itemBuilder: (context, index) =>
                            WorkoutTile(workout: state.workouts[index]),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addWorkout(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
