# Fitness Tracker

A cross-platform fitness tracker built with **Flutter**. This is the Flutter
reimplementation of the Android Kotlin app — same features, but with a senior-grade
**Clean Architecture** (BLoC + `get_it` + local DB + network layer).

## Features

- Record a workout: enter **steps** and **duration** (minutes).
- Calories are derived automatically from the domain rule (`steps * 0.04`).
- Live totals: **total steps**, **total calories**, **total distance (km)**.
- Workout history, newest first, persisted locally (survives restart).

## Tech stack

| Concern | Choice |
| --- | --- |
| Language / UI | Dart + Flutter (Material 3) |
| State management | `flutter_bloc` (Cubits) |
| Dependency injection | `get_it` |
| Local database | `hive` + `hive_flutter` (manual `TypeAdapter`, no codegen) |
| Networking | `dio` (abstract `RemoteWorkoutApi` + mock, ready to swap in a real backend) |
| Equality / immutability | `equatable` |
| Date formatting | `intl` |
| Testing | `flutter_test`, `bloc_test`, `mocktail` |
| Linting | `flutter_lints` + strict rules (`flutter analyze` → 0 issues) |

## Architecture

Clean Architecture, three layers:

```
lib/
├── domain/            # pure Dart: entities, use cases, repository interfaces
│   ├── entities/workout.dart
│   ├── repositories/workout_repository.dart
│   └── use_cases/{add_workout, get_workouts}.dart
├── data/              # repository impl + data sources (Hive local, Dio remote)
│   ├── datasources/{workout_local_data_source, workout_remote_data_source}.dart
│   ├── models/workout_model.dart
│   └── repositories/workout_repository_impl.dart
├── presentation/      # widgets + state management (Cubit)
│   ├── cubit/{tracker_cubit, tracker_state}.dart
│   ├── pages/home_page.dart
│   └── widgets/{stats_header, workout_tile, add_workout_dialog}.dart
├── di/injection.dart  # get_it wiring
├── app.dart
└── main.dart
```

**Data flow:** widget → Cubit → use case → repository interface → data sources.
Widgets are dumb (no `setState` for business logic); all logic lives in the
domain and data layers.

## Getting started

```bash
flutter pub get
flutter run
```

## Quality checks

```bash
flutter analyze   # 0 issues (strict lints)
flutter test      # unit tests for domain, data, presentation
```

## Extending

- **Swap the local DB to Isar:** implement `WorkoutLocalDataSource` against Isar
  and change one line in `lib/di/injection.dart` — the repository interface is
  storage-agnostic.
- **Wire a real backend:** replace `MockRemoteWorkoutApi` with
  `DioRemoteWorkoutApi(dio: ..., baseUrl: ...)` in `lib/di/injection.dart`.
