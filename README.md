# 🏃 Fitness Tracker

Приложение для отслеживания тренировок: шаги, калории, длительность и дистанция.

Есть две версии:

| Версия | Стек | Платформа | Статус |
| --- | --- | --- | --- |
| **v2.0** | Flutter (Dart), Clean Architecture + BLoC + Hive + Dio | Android + iOS | актуальная (в `flutter/`) |
| **v1.0** | Kotlin + Coroutines, MVVM, Room | Android | legacy (в корне) |

## v2.0 — Flutter (в `flutter/`)

Кроссплатформенная переработка с продовой архитектурой:

- **Clean Architecture**: `domain/` (entities, use cases, интерфейсы репозиториев) → `data/` (Hive + Dio) → `presentation/` (BLoC/Cubit + виджеты).
- **State management**: `flutter_bloc` (Cubit) — без `setState` для бизнес-логики.
- **DI**: `get_it`.
- **Локальная БД**: `hive` (ручной `TypeAdapter`).
- **Сетевой слой**: `dio` + абстрактный `RemoteWorkoutApi` (мок готов к замене на реальный бэкенд).
- **Качество**: `flutter analyze` → 0 issues, `flutter test` — unit-тесты (domain/data/presentation).

```bash
cd flutter
flutter pub get
flutter run
flutter analyze   # 0 issues
flutter test      # все тесты зелёные
```

Подробнее — [flutter/README.md](flutter/README.md).

## v1.0 — Kotlin (в корне)

- **Kotlin** + Coroutines, **MVVM**, **Room**, **LiveData** + ViewBinding.

## 📦 Releases

- [v2.0 — Flutter](https://github.com/Leonov792/FitnessTrackerApp/releases/tag/v2.0.0)
- [v1.0 — Kotlin APK](https://github.com/Leonov792/FitnessTrackerApp/releases/tag/v1.0)
