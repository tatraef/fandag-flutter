# fandag

Production-ready шаблон Flutter-приложения на **Riverpod-архитектуре** (Feature-First, MVVM + Repository).

## Требования

- **Flutter SDK**: 3.38.5 (управляется через FVM)
- **Dart SDK**: 3.10.4
- **iOS**: Xcode 15+, CocoaPods
- **Android**: Android Studio / SDK Platform 34+

Подробная инструкция по настройке: [docs/app-setup.md](docs/app-setup.md)

## Быстрый старт

```bash
make setup      # Установить FVM + зависимости
make init       # Полная инициализация (FVM + deps + codegen + translations)
make run        # Запуск приложения (dev)
```

## Make-команды

Мы используем `make` для выполнения различных команд. Если вы постоянно выполняете одну и ту же команду и ее нет в Makefile — добавьте ее туда.

### Основные команды

```bash
make help       # Показать все доступные команды
make setup      # Установить FVM + зависимости
make init       # Полная инициализация (FVM + deps + codegen + translations)
make i          # flutter pub get
```

### Кодогенерация

```bash
make gen            # Одноразовая кодогенерация (build_runner)
make watch          # Кодогенерация в watch-режиме
make translations   # Генерация переводов (slang)
make theme-gen      # Генерация файлов темы (palette, colors, fonts)
```

### Запуск приложения

```bash
make run        # Запуск (dev)
make run-mock   # Запуск с мок-данными (без бэкенда)
make ios        # Запуск на iOS-симуляторе
make android    # Запуск на Android-эмуляторе
```

### Сборка

```bash
make build-apk  # Сборка release APK
make build-ios  # Сборка iOS (без подписи)
make build-ipa  # Сборка IPA
```

### Тестирование

```bash
make test              # Запуск всех тестов
make test-unit         # Только unit-тесты
make test-widget       # Только widget-тесты
make test-integration  # Только integration-тесты
make test-coverage     # Тесты с отчетом о покрытии
make test-watch        # Тесты в watch-режиме
```

### Анализ и форматирование

```bash
make analyze    # Статический анализ
make format     # Форматирование кода
make lint       # Анализ + форматирование
```

### Очистка

```bash
make clean      # Flutter clean + pub get
make clean-all  # Clean + удаление сгенерированных файлов
```

## Стек технологий

| Область | Пакет |
|---|---|
| State Management | flutter_riverpod + riverpod_annotation (codegen) |
| Навигация | go_router |
| Сеть | dio |
| Локальное хранилище | drift, shared_preferences, flutter_secure_storage |
| Модели | freezed + json_serializable |
| Локализация | slang (i18n.json, en/ru) |
| Firebase | firebase_core, crashlytics, analytics, messaging |
| Отладка | MadInspector (debug menu, network inspector, server selection) |
| Окружение | FVM (Flutter Version Management) |
| Версионирование | Все зависимости зафиксированы (без `^`) |

## Архитектура

Шаблон использует **Feature-First** подход с **MVVM + Repository** паттерном. Каждая фича содержит три слоя: `domain`, `data` и `presentation`.

```
lib/
├── main.dart                   # Точка входа
├── app.dart                    # MaterialApp + ProviderScope
├── core/                       # Общие модули
│   ├── core.dart               # Агрегирующий barrel-файл
│   ├── constants/              # API endpoints, durations
│   ├── environment/            # Сгенерированные секреты
│   ├── extensions/             # context_ext, string_ext
│   ├── inspector/              # MadInspector init, server config
│   ├── translations/            # JSON-файлы + сгенерированное (slang)
│   ├── network/                # Dio provider, interceptor, exceptions
│   ├── router/                 # GoRouter + AppRoute enum
│   ├── storage/                # SharedPrefs, SecureStorage, Drift DB
│   ├── theme/                  # ThemeExtensions, light/dark themes
│   └── widgets/                # Общие виджеты (button, text field, loading)
└── features/                   # Фичи приложения
    ├── auth/                   # Авторизация (sign in, sign up, password recovery)
    │   ├── domain/             # Entities, repository interfaces
    │   ├── data/               # DTOs, datasources, repository impls
    │   └── presentation/       # Controllers, pages, widgets
    └── home/                   # Посты (CRUD)
        ├── domain/
        ├── data/
        └── presentation/
```

### Слои фичи

- **domain/** — Entities (Freezed, без JSON), интерфейсы репозиториев
- **data/** — DTO (Freezed + JSON + `toDomain()`), datasource-ы, реализации репозиториев
- **presentation/** — Controllers (Riverpod codegen), pages, widgets

### Управление состоянием (Riverpod)

Все провайдеры создаются через **кодогенерацию**:

```dart
@riverpod                          // auto-dispose провайдер
Future<List<Post>> posts(Ref ref) async { ... }

@Riverpod(keepAlive: true)         // singleton-провайдер
Dio dio(Ref ref) { ... }
```

Ручные провайдеры (`final myProvider = Provider(...)`) **не используются**.

### Модели (Freezed)

Domain entities — без JSON:
```dart
@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String name,
  }) = _User;
}
```

DTO — с JSON + маппинг в domain:
```dart
@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required int id,
    required String name,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}
```

## Кодогенерация

После изменения Freezed-моделей, Riverpod-провайдеров или Drift-таблиц:

```bash
make gen        # Одноразовая генерация
make watch      # Watch-режим
```

Сгенерированные файлы (`*.g.dart`, `*.freezed.dart`) коммитятся в git.

## Локализация

Переводы хранятся в JSON-файлах:
- `lib/core/translations/en.i18n.json`
- `lib/core/translations/ru.i18n.json`

Доступ в коде через расширение контекста:
```dart
Text(context.t.auth.signIn.title)
```

После изменения JSON-файлов:
```bash
make translations    # Генерация Dart-файлов (включено в make init)
```

Генератор: **slang** (type-safe переводы с поддержкой интерполяции)

## Стиль кода

- **Явные типы везде** — включен `always_specify_types`
- **Одинарные кавычки** для строк
- **Пустая строка перед `return`**
- **Никаких магических чисел** — выносить в именованные константы
- **Виджеты — только классы** (`StatelessWidget`, `ConsumerWidget` и т.д.), никаких widget-функций
- **Конструкторы первыми** в теле класса
- **`const` везде, где возможно**
- **`final` для переменных и полей**, которые не переназначаются
- **Strict mode**: `strict-casts`, `strict-inference`, `strict-raw-types`

Перед каждым МР необходимо отформатировать код: `make lint`

## Тестирование

Тесты зеркалят структуру `lib/` в папке `test/`.

```bash
make test            # Запуск тестов
make test-coverage   # Тесты с покрытием
```

## CI/CD

Проект настроен для автоматизации через Fastlane:
- **iOS**: Fastlane + Match для управления сертификатами
- **Android**: Keystore конфигурация в `android/key.properties`
- **Firebase**: Crashlytics, Analytics, Push-уведомления

Подробности сборки и деплоя: см. `fastlane/Fastfile`

## MadInspector

Набор инструментов для тестирования и отладки: логирование, прокси, HTTP-запросы, выбор сервера, мониторинг производительности, debug-меню.

Для открытия — потрясти девайс или вызвать `MadInspectorView.attachTo(context)`.

[Подробнее о MadInspector](https://git.mb-dev.ru/madbrains/internal/mad-inspector-flutter/-/blob/v3/README.md)

## Документация

**Навигация по документации**: [`docs/README.md`](docs/README.md)

### Основные разделы:

- **Fundamentals** — структура проекта, стек технологий, workflow
- **Architecture** — MVVM + Repository, Riverpod, навигация, обработка ошибок
- **Data Layer** — репозитории, DTO-маппинг, networking, storage
- **Presentation** — контроллеры, страницы, виджеты, темизация
- **Conventions** — barrel-файлы, стиль кода, импорты
- **Reference** — чеклист добавления фичи, паттерны, core-виджеты
- **Testing** — unit, widget, integration тесты, лучшие практики

Быстрый старт для новой фичи: [docs/reference/adding-feature.md](docs/reference/adding-feature.md)
