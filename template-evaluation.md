# Оценка Flutter Template v3 (2026-03-11)

Оценка построена на фактическом состоянии репозитория: `lib/`, `docs/`, `Makefile`, а также на содержимом `.claude/agents`, `.claude/skills`, `.claude/hooks`.

## 1) Качество кода, логичность и архитектура — 8.6/10

**Что хорошо (по коду и структуре):**
- Feature-first + слои `domain/` → `data/` → `presentation/` внутри фич (пример: `lib/features/auth/`, `lib/features/home/`).
- Чёткие правила зависимостей и разделение ответственности подтверждаются на реальных фичах:
  - `presentation` не лезет в `data` напрямую, работает через интерфейсы домена + провайдеры.
  - Datasource возвращает DTO, репозиторий конвертит в доменные сущности (пример: `lib/features/home/data/datasources/home_remote_datasource.dart`, `lib/features/home/data/repositories/home_repository_impl.dart`).
- Error handling сделан централизованно и типизированно:
  - `ApiClient` конвертит ошибки в `ApiException` через `ApiExceptionConverter` (`lib/core/network/api_client.dart`, `lib/core/network/api_exception_converter.dart`).
  - UI локализует ошибки через feature-specific extension (пример: `lib/features/auth/presentation/extensions/auth_error_ext.dart` + `lib/core/extensions/context_ext.dart`).
- Riverpod codegen используется последовательно (контроллеры и провайдеры), DI wiring читаемый (пример: `lib/features/auth/presentation/controllers/auth_providers.dart`).
- Линты и строгая типизация реально включены: `always_specify_types`, `strict-casts`, `strict-inference`, `strict-raw-types`, `always_use_package_imports` и т.д. (`analysis_options.yaml`).

**Риски/недочёты (не ломают, но замедляют и/или плодят расхождения):**
- Накладные расходы на barrel-иерархию: дисциплина высокая, но цена в “постоянных правках экспортов” ощутимая (частично компенсируется хуком `check-barrel-export.sh`).
- Повторяющийся шаблон `if (data == null) throw StateError('Response body is null')` в datasource (пример: `lib/features/auth/data/datasources/auth_remote_datasource.dart`) можно стандартизировать (хелпер/extension), иначе это будет размножаться во всех фичах.
- `AuthRepositoryImpl` держит `StreamController<bool>.broadcast()` без явного закрытия (`lib/features/auth/data/repositories/auth_repository_impl.dart`): если репозиторий действительно singleton на весь жизненный цикл приложения, это ок; но в тестах/перезапусках может быть источником “висящих” ресурсов.

## 2) Качество документации для ИИ-агентов (двусмысленность, детерминизм) — 8.7/10

**Сильные стороны (реально помогает агентам):**
- `docs/README.md` как “навигатор” с таблицей “задача → документ” и рекомендуемым порядком чтения.
- Много “жёстких” правил (линты, импорты, именование, чеклисты pre-commit) + decision tree (например `docs/presentation/controllers.md`).
- Документация не только описательная: есть анти-паттерны, объяснения “почему”, примеры кода и “канонические” файлы (`docs/reference/patterns-reference.md`, `docs/reference/adding-feature.md`).
- Команды централизованы в `Makefile`, workflow описан пошагово (`docs/fundamentals/development-workflow.md`).

**Текущее состояние (после обновления network-клиента):**
- Паттерн datasource/DI приведён к единому “источнику истины”: datasource работает через `ApiClient`, ошибки конвертируются централизованно (`ApiExceptionConverter`), репозитории не мапят `DioException` вручную.
- Команды тестирования в документации выровнены под FVM (`fvm flutter ...`) для снижения расхождений по версии SDK.

## 3) Качество скиллов, команд и агентов — 8.6/10

**Что сделано хорошо (и это реально “AI-friendly”):**
- Есть набор специализированных скиллов в `.claude/skills/*/SKILL.md` (фактически 16 штук: entity/dto/controller/provider/datasource/page/widget/barrel/navigation/theme/fonts/repository/mock/translations/tdd и т.д.).
- Есть агенты в `.claude/agents/` (domain/data/presentation implementers, theme manager, test runner) с подключёнными скиллами и хуками.
- Хуки дают “ограждения” и повышают детерминизм:
  - запрет ручного редактирования `*.g.dart`/`*.freezed.dart` (`.claude/hooks/validate-*-write.sh`);
  - проверка экспортов в sub-barrel (`.claude/hooks/check-barrel-export.sh`);
  - авто-форматирование (`.claude/hooks/format-hook.sh`).
- Команды разработки централизованы и предсказуемы (`Makefile`), есть генераторы/скрипты для шаблонизации (например `tools/template_scripts/...` и `make theme-gen`).

**Недочёты (точечные):**
- Важно удерживать единый паттерн `ApiClient` в примерах: при следующих изменениях network-слоя стоит обновлять одновременно `docs/` и `.claude/skills`, иначе снова появятся “две истины”.

## Итоговая оценка: **8.6/10**

| Критерий | Оценка |
|----------|--------|
| Код и архитектура | 8.6 |
| Документация для ИИ | 8.7 |
| Скиллы/команды/агенты | 8.6 |
| **Среднее** | **8.6** |

## Рекомендации (самые “окупаемые”)

1. Поддерживать “single source of truth” для networking: `ApiClient` + `ApiExceptionConverter`, без ручного маппинга `DioException` в репозиториях.
2. Добавить быстрый “sanity checklist” для агента: что открыть/прочитать в первую очередь при создании новой фичи, и какие файлы считать каноническими (чтобы снижать риск расхождений).
