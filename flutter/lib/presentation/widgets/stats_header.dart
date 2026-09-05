import 'package:flutter/material.dart';

class StatsHeader extends StatelessWidget {
  const StatsHeader({
    super.key,
    required this.steps,
    required this.calories,
    required this.distanceKm,
  });

  final int steps;
  final int calories;
  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: 'Steps', value: '$steps'),
          _Stat(label: 'Calories', value: '$calories'),
          _Stat(
            label: 'Distance',
            value: '${distanceKm.toStringAsFixed(1)} km',
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
