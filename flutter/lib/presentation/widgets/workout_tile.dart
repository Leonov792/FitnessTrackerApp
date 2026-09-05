import 'package:fitness_tracker/domain/entities/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkoutTile extends StatelessWidget {
  const WorkoutTile({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd.MM.yyyy HH:mm').format(workout.date);
    return ListTile(
      leading: const Icon(Icons.directions_walk),
      title: Text('${workout.steps} steps'),
      subtitle: Text(date),
      trailing: Text('${workout.calories} kcal'),
    );
  }
}
