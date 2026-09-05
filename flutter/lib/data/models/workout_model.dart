import 'package:fitness_tracker/domain/entities/workout.dart';
import 'package:hive/hive.dart';

/// Persisted representation of a [Workout] (Hive object + JSON).
class WorkoutModel {
  const WorkoutModel({
    required this.id,
    required this.steps,
    required this.calories,
    required this.durationMinutes,
    required this.date,
  });

  factory WorkoutModel.fromEntity(Workout workout) => WorkoutModel(
    id: workout.id,
    steps: workout.steps,
    calories: workout.calories,
    durationMinutes: workout.durationMinutes,
    date: workout.date,
  );

  factory WorkoutModel.fromJson(Map<String, dynamic> json) => WorkoutModel(
    id: json['id'] as int,
    steps: json['steps'] as int,
    calories: json['calories'] as int,
    durationMinutes: json['durationMinutes'] as int,
    date: DateTime.parse(json['date'] as String),
  );

  final int id;
  final int steps;
  final int calories;
  final int durationMinutes;
  final DateTime date;

  Workout toEntity() => Workout(
    id: id,
    steps: steps,
    calories: calories,
    durationMinutes: durationMinutes,
    date: date,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'steps': steps,
    'calories': calories,
    'durationMinutes': durationMinutes,
    'date': date.toIso8601String(),
  };
}

/// Hand-written Hive [TypeAdapter] for [WorkoutModel] (no code generation).
class WorkoutModelAdapter extends TypeAdapter<WorkoutModel> {
  @override
  final int typeId = 0;

  @override
  WorkoutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutModel(
      id: fields[0] as int,
      steps: fields[1] as int,
      calories: fields[2] as int,
      durationMinutes: fields[3] as int,
      date: DateTime.parse(fields[4] as String),
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.steps)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.durationMinutes)
      ..writeByte(4)
      ..write(obj.date.toIso8601String());
  }
}
