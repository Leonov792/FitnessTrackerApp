import 'package:fitness_tracker/domain/entities/workout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Workout', () {
    test('caloriesFor derives calories from steps', () {
      expect(Workout.caloriesFor(100), 4);
      expect(Workout.caloriesFor(0), 0);
    });

    test('distanceKmFor derives distance from steps', () {
      expect(Workout.distanceKmFor(1000), closeTo(0.8, 0.0001));
    });

    test('props drives equality', () {
      final a = Workout(
        id: 1,
        steps: 100,
        calories: 4,
        durationMinutes: 30,
        date: DateTime(2024),
      );
      final b = Workout(
        id: 1,
        steps: 100,
        calories: 4,
        durationMinutes: 30,
        date: DateTime(2024),
      );
      expect(a, equals(b));
    });
  });
}
