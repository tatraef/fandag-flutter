# Flutter Template v3: AI-Friendly архитектура

## Зачем новый шаблон?

Template v2 верно служил на многих проектах, но мир изменился. AI-ассистенты (Cursor, Claude Code, Copilot) стали полноценными участниками разработки. И оказалось, что архитектура, удобная для человека, не всегда удобна для AI.

Мы переосмыслили шаблон с нуля, задавшись вопросом: **как должен выглядеть проект, в котором AI-ассистент работает с максимальной эффективностью?**

---

## Что изменилось

### 1. Пакетная структура → Feature-First монолит

**v2:** 5 пакетов (`app`, `data`, `domain`, `state`, `app_data_common`) в папке `packages/`. Каждая фича размазана по нескольким пакетам.

**v3:** Один пакет, фичи в `lib/features/`. Каждая фича — самодостаточная папка с `domain/`, `data/`, `presentation/`.

```
# v2 — чтобы добавить экран заказов, правим 4 пакета:
packages/domain/models/order.dart
packages/data/repository_impl/order_repository_impl.dart
packages/state/local/order_bloc.dart
packages/app/ui/orders/order_page.dart

# v3 — всё в одном месте:
lib/features/order/
├── domain/     # entity + repository interface
├── data/       # dto + datasource + repository impl
└── presentation/  # controller + page + widgets
```

**Почему?** AI работает с контекстом. Чем ближе связанные файлы друг к другу, тем точнее AI понимает задачу. Когда вся фича в одной папке — ассистент видит полную картину, а не собирает пазл из 4 пакетов.

### 2. BLoC → Riverpod с кодогенерацией

**v2:** BLoC — Event, State, Bloc, отдельные файлы для каждого. Ручной DI.

**v3:** Riverpod + `@riverpod` аннотации. Провайдеры генерируются автоматически.

```dart
// v2 — BLoC: 3 файла, ~100 строк бойлерплейта
class OrderEvent { ... }
class OrderState { ... }
class OrderBloc extends Bloc<OrderEvent, OrderState> { ... }
// + ручная регистрация в DI

// v3 — Riverpod: 1 файл, ~15 строк
@riverpod
class OrderListController extends _$OrderListController {
  @override
  Future<List<Order>> build() async {
    return ref.read(orderRepositoryProvider).getOrders();
  }
}
// Провайдер сгенерирован автоматически
```

**Почему?** Меньше бойлерплейта = меньше ошибок AI. Кодогенерация убирает целый класс проблем: AI не может неправильно зарегистрировать провайдер или забыть передать зависимость — компилятор и генератор это контролируют.

### 3. Нет документации → CLAUDE.md + структурированная docs/

**v2:** README со ссылками на wiki. Контекст проекта — в головах разработчиков.

**v3:** `CLAUDE.md` в корне проекта + полная структурированная документация в `docs/`:

**Fundamentals** (основы)
- `tech-stack.md` — каждый пакет с обоснованием выбора
- `project-structure.md` — полное дерево проекта с пояснениями
- `development-workflow.md` — команды и git-процесс

**Architecture** (архитектура)
- `overview.md` — MVVM + Repository pattern, слои, data flow
- `riverpod-providers.md` — типы провайдеров, DI, правила ref
- `error-handling.md` — иерархия ApiException
- `navigation.md` — GoRouter, AppRoute, auth-редиректы

**Data Layer** (слой данных)
- `repository-pattern.md` — entity, интерфейсы, реализации
- `dto-mapping.md` — Freezed DTOs, fromJson, toDomain()
- `networking.md` — Dio provider, interceptor, endpoints
- `storage.md` — Drift DB, SecureStorage, SharedPreferences

**Presentation** (слой UI)
- `controllers.md` — form, async list, global state паттерны
- `pages-and-widgets.md` — ConsumerWidget, Consumer+select(), правила виджетов
- `theming.md` — ThemeColors, PrimaryFonts, extensions

**Conventions** (конвенции)
- `barrel-files.md` — двухуровневая иерархия barrel-файлов
- `code-style.md` — все правила стиля и линтинга
- `imports-and-dependencies.md` — порядок импортов, версионирование

**Reference** (справка)
- `adding-feature.md` — пошаговый чеклист добавления фичи
- `patterns-reference.md` — quick-lookup таблица паттернов
- `core-widgets.md` — API общих виджетов

**Testing** (тестирование)
- `overview.md`, `what-to-test.md`, `unit-testing.md`, `widget-testing.md`, `integration-testing.md`, `best-practices.md`, `troubleshooting.md`

**Почему?** `CLAUDE.md` — это «инструкция для AI». Когда ассистент открывает проект, он первым делом читает этот файл и сразу понимает: какая архитектура, какие конвенции, как именовать файлы, куда что класть. Документация разбита по задачам — для каждого действия есть конкретный гайд. Без `CLAUDE.md` и структурированной docs/ AI будет угадывать — и ошибаться.

### 4. Свободная структура → Жёсткие конвенции

**v2:** Общие рекомендации по стилю кода.

**v3:** Формализованные правила на каждый аспект:
- **Barrel-файлы:** двухуровневая иерархия (sub-barrel → layer barrel). Никогда не экспортировать файлы из layer barrel напрямую.
- **Freezed-модели:** domain entity без JSON, DTO с `fromJson` + `toDomain()`. Только `abstract class`.
- **Импорты:** только абсолютные (`package:flutter_template_v3/...`). Порядок: `dart:` → `package:` → project.
- **Стиль:** explicit types, single quotes, `const`/`final` везде, пустая строка перед `return`.

**Почему?** AI силен в следовании правилам, если правила чёткие. Размытые конвенции = непредсказуемый результат. Жёсткие конвенции = AI генерирует код, который не нужно переписывать.

### 5. RxDart → Нативные возможности Riverpod

**v2:** BehaviorSubject, CombineLatestStream, shareValue — ручное управление стримами.

**v3:** Riverpod из коробки дает реактивность через `ref.watch`, `AsyncValue`, автоматический dispose. RxDart не нужен.

**Почему?** Меньше концепций в стеке = AI быстрее ориентируется. Не нужно понимать тонкости `publishValue` vs `shareValue` — Riverpod решает те же задачи проще.

---

## Что делает шаблон AI-Friendly

### Предсказуемость структуры
Каждая фича выглядит одинаково. AI, увидев одну фичу, точно знает, как создать другую. Пошаговый чеклист в `adding-feature.md` — это по сути prompt для AI.

### Контекст в одном месте
`CLAUDE.md` содержит краткую инструкцию и ссылки на детальную документацию. `docs/README.md` — навигационный хаб с маппингом "задача → документ". Не нужно бродить по wiki или спрашивать коллег — всё в репозитории.

### Кодогенерация как safety net
Freezed, Riverpod Generator, json_serializable — генераторы ловят ошибки на этапе `make gen`. Если AI написал модель с неправильной структурой — build_runner скажет об этом раньше, чем код попадет в рантайм.

### Строгий анализ
`strict-casts`, `strict-inference`, `strict-raw-types`, `always_specify_types` — анализатор не даст AI пропустить тип или сделать небезопасный каст. Код от AI проходит те же проверки, что и от человека.

---

## Итого

| | Template v2 | Template v3 |
|---|---|---|
| **Структура** | Пакетная (5 пакетов) | Feature-first монолит |
| **State Management** | BLoC / Redux | Riverpod (codegen) |
| **DI** | Ручной | Riverpod (codegen) |
| **Модели** | Freezed | Freezed (abstract class) |
| **Реактивность** | RxDart | Riverpod ref.watch |
| **Локализация** | intl + ARB | slang (type-safe, nested JSON) |
| **Навигация** | Custom / auto_route | go_router |
| **AI-контекст** | Нет | CLAUDE.md + структурированная docs/ |
| **Конвенции** | Рекомендации | Формализованные правила |
| **Анализ** | Базовый | Strict mode + always_specify_types |
| **Тестирование** | Базовое | Полная документация + best practices |

Шаблон уже можно использовать на новых проектах. Документация и примеры — в самом репозитории.

### Ключевые преимущества для разработки с AI

1. **Меньше контекста = лучше результат** — AI не распыляется между пакетами
2. **Кодогенерация = safety net** — ошибки ловятся на этапе `make gen`, а не в рантайме
3. **Строгие правила = предсказуемый код** — AI следует конвенциям, результат не нужно переписывать
4. **Документация в репозитории** — AI читает `CLAUDE.md` и сразу понимает архитектуру
5. **Меньше бойлерплейта = меньше ошибок** — Riverpod codegen убирает целый класс проблем с DI
