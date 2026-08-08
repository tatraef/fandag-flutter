# Adding a New Feature

> **Execution Order**: Follow steps 1–8 strictly in sequence. Each step depends on the previous. Do not skip steps.

Step-by-step checklist for adding a feature. Use the `auth` or `home` feature as a reference.

---

## 1. Create Folder Structure

```
lib/features/<feature_name>/
├── domain/
│   ├── domain.dart              # Layer barrel (exports sub-barrels)
│   ├── entities/
│   │   └── entities.dart        # Sub-barrel
│   └── repositories/
│       └── repositories.dart    # Sub-barrel
├── data/
│   ├── data.dart                # Layer barrel (exports sub-barrels)
│   ├── datasources/
│   │   └── datasources.dart     # Sub-barrel
│   ├── models/
│   │   └── models.dart          # Sub-barrel
│   └── repositories/
│       └── repositories.dart    # Sub-barrel
└── presentation/
    ├── presentation.dart        # Layer barrel (exports sub-barrels)
    ├── controllers/
    │   └── controllers.dart     # Sub-barrel
    ├── pages/
    │   └── pages.dart           # Sub-barrel
    └── widgets/
        └── widgets.dart         # Sub-barrel
```

---

## 2. Domain Layer

### 2.1 Entities

Create Freezed entities in `domain/entities/`. Domain entities have no JSON serialisation.

```dart
// domain/entities/order.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String title,
    required double total,
  }) = _Order;
}
```

### 2.2 Repository Interface

Create an abstract class in `domain/repositories/`.

```dart
// domain/repositories/order_repository.dart
import 'package:fandag/features/order/domain/entities/entities.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrderById(String id);
}
```

### 2.3 Sub-barrels & Domain Barrel

```dart
// domain/entities/entities.dart
export 'order.dart';
```

```dart
// domain/repositories/repositories.dart
export 'order_repository.dart';
```

```dart
// domain/domain.dart
export 'entities/entities.dart';
export 'repositories/repositories.dart';
```

**Barrel Checklist — Domain:**
- [ ] `domain/entities/entities.dart` — exports all entity files
- [ ] `domain/repositories/repositories.dart` — exports all repository interface files
- [ ] `domain/domain.dart` — exports `entities/entities.dart` and `repositories/repositories.dart` ONLY

> **Run `make gen`** now to generate `.freezed.dart` files for your entities.

---

## 3. Data Layer

### 3.1 DTOs

Create Freezed + json_serializable models in `data/models/`. Each DTO has a `toDomain()` method.

```dart
// data/models/order_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fandag/features/order/domain/domain.dart';

part 'order_dto.freezed.dart';
part 'order_dto.g.dart';

@freezed
abstract class OrderDto with _$OrderDto {
  const factory OrderDto({
    required String id,
    required String title,
    required double total,
  }) = _OrderDto;

  const OrderDto._();

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  Order toDomain() {
    return Order(id: id, title: title, total: total);
  }
}
```

### 3.2 Data Source

```dart
// data/datasources/order_remote_datasource.dart
import 'package:fandag/core/constants/constants.dart';
import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/order/data/models/models.dart';

class OrderRemoteDataSource {
  OrderRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<List<OrderDto>> getOrders() async {
    final Response<List<dynamic>> response =
        await _apiClient.get<List<dynamic>>(ApiEndpoints.orders);
    final List<dynamic> data = response.data ?? <dynamic>[];

    return data.cast<Map<String, dynamic>>().map(OrderDto.fromJson).toList();
  }
}
```

### 3.3 Repository Implementation

```dart
// data/repositories/order_repository_impl.dart
import 'package:fandag/features/order/data/datasources/datasources.dart';
import 'package:fandag/features/order/domain/domain.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl({required OrderRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final OrderRemoteDataSource _remoteDataSource;

  @override
  Future<List<Order>> getOrders() async {
    final List<OrderDto> dtos = await _remoteDataSource.getOrders();

    return dtos.map((OrderDto dto) => dto.toDomain()).toList();
  }
}
```

### 3.4 Sub-barrels & Data Barrel

```dart
// data/datasources/datasources.dart
export 'order_remote_datasource.dart';
```

```dart
// data/models/models.dart
export 'order_dto.dart';
```

```dart
// data/repositories/repositories.dart
export 'order_repository_impl.dart';
```

```dart
// data/data.dart
export 'datasources/datasources.dart';
export 'models/models.dart';
export 'repositories/repositories.dart';
```

**Barrel Checklist — Data:**
- [ ] `data/models/models.dart` — exports all DTO and request model files
- [ ] `data/datasources/datasources.dart` — exports all datasource files
- [ ] `data/repositories/repositories.dart` — exports all repository impl files
- [ ] `data/data.dart` — exports `models/models.dart`, `datasources/datasources.dart`, and `repositories/repositories.dart` ONLY

> **Run `make gen`** now to generate `.freezed.dart` and `.g.dart` files for your DTOs.

---

## 4. Presentation Layer

### 4.1 Providers (DI Wiring)

Create a `<feature>_providers.dart` file that wires data source -> repository.

```dart
// presentation/controllers/order_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fandag/core/network/network.dart';
import 'package:fandag/features/order/data/data.dart';
import 'package:fandag/features/order/domain/domain.dart';

part 'order_providers.g.dart';

@Riverpod(keepAlive: true)
OrderRemoteDataSource orderRemoteDataSource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);

  return OrderRemoteDataSource(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) {
  return OrderRepositoryImpl(
    remoteDataSource: ref.watch(orderRemoteDataSourceProvider),
  );
}
```

### 4.2 Controller (ViewModel)

```dart
// presentation/controllers/order_list_controller.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fandag/features/order/domain/domain.dart';
import 'package:fandag/features/order/presentation/controllers/controllers.dart';

part 'order_list_controller.g.dart';

@riverpod
class OrderListController extends _$OrderListController {
  @override
  Future<List<Order>> build() async {
    return ref.read(orderRepositoryProvider).getOrders();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<Order>>();
    try {
      final List<Order> orders = await ref.read(orderRepositoryProvider).getOrders();
      state = AsyncData<List<Order>>(orders);
    } on Exception catch (e, st) {
      state = AsyncError<List<Order>>(e, st);
    }
  }
}
```

> **Run `make gen`** now to generate `.g.dart` files for your providers and controllers.

### 4.3 Page

Use `ConsumerWidget` or `ConsumerStatefulWidget`. Never use widget functions.

```dart
// presentation/pages/order_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fandag/features/order/domain/domain.dart';
import 'package:fandag/features/order/presentation/controllers/controllers.dart';

class OrderListPage extends ConsumerWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Order>> state = ref.watch(orderListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.t.order.title)),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object e, _) => Center(child: Text(e.toString())),
        data: (List<Order> orders) => ListView.builder(
          itemCount: orders.length,
          itemBuilder: (BuildContext context, int index) => Text(orders[index].title),
        ),
      ),
    );
  }
}
```

### 4.4 Widgets

Extract reusable widgets into `presentation/widgets/` as separate classes.

### 4.5 Sub-barrels & Presentation Barrel

```dart
// presentation/controllers/controllers.dart
export 'order_list_controller.dart';
export 'order_providers.dart';
```

```dart
// presentation/pages/pages.dart
export 'order_list_page.dart';
```

```dart
// presentation/widgets/widgets.dart
// (add widget exports here as you create them)
```

```dart
// presentation/presentation.dart
export 'controllers/controllers.dart';
export 'pages/pages.dart';
export 'widgets/widgets.dart';
```

**Barrel Checklist — Presentation:**
- [ ] `presentation/controllers/controllers.dart` — exports all controller and provider files
- [ ] `presentation/pages/pages.dart` — exports all page files
- [ ] `presentation/widgets/widgets.dart` — exports all widget files
- [ ] `presentation/presentation.dart` — exports `controllers/controllers.dart`, `pages/pages.dart`, and `widgets/widgets.dart` ONLY

---

## 5. Routes

### 5.1 Add to `AppRoute` enum

```dart
// core/router/app_route.dart
enum AppRoute {
  // ... existing routes
  orderList('/orders'),
  ;

  const AppRoute(this.path);
  final String path;
}
```

### 5.2 Add GoRoute

```dart
// core/router/app_router.dart -- inside routes list
GoRoute(
  path: AppRoute.orderList.path,
  builder: (BuildContext context, GoRouterState state) =>
      const OrderListPage(),
),
```

---

## 6. Translations

Add keys to both JSON files using nested structure:

```json
// core/translations/en.i18n.json — add a new group or keys to an existing group
{
  "order": {
    "title": "Orders",
    "empty": "No orders yet"
  }
}

// core/translations/ru.i18n.json
{
  "order": {
    "title": "Заказы",
    "empty": "Заказов пока нет"
  }
}
```

Then regenerate: `make translations` (or `fvm dart run slang`).

Access in widgets: `context.t.order.title`

---

## 7. Code Generation

```bash
make gen
```

This generates `*.freezed.dart`, `*.g.dart` for all new models, controllers, and providers.

---

## 8. Tests

Create a mirrored structure under `test/`:

```
test/features/<feature_name>/
├── domain/
│   └── ...
├── data/
│   └── ...
└── presentation/
    └── ...
```

---

## Cross-References

For detailed documentation on each concept, refer to:

- **Entities & Repositories**: [repository-pattern.md](../data-layer/repository-pattern.md)
- **DTOs & JSON mapping**: [dto-mapping.md](../data-layer/dto-mapping.md)
- **Datasources & Dio**: [networking.md](../data-layer/networking.md)
- **Controller patterns**: [controllers.md](../presentation/controllers.md)
- **Pages & widgets**: [pages-and-widgets.md](../presentation/pages-and-widgets.md)
- **Riverpod providers**: [riverpod-providers.md](../architecture/riverpod-providers.md)
- **Barrel file rules**: [barrel-files.md](../conventions/barrel-files.md)
- **Error handling**: [error-handling.md](../architecture/error-handling.md)
- **Navigation & routing**: [navigation.md](../architecture/navigation.md)
- **Canonical patterns**: [patterns-reference.md](patterns-reference.md)

---

## Final Checklist

- [ ] Folder structure created: `domain/`, `data/`, `presentation/`
- [ ] Domain entities with `@freezed` (no JSON)
- [ ] Abstract repository in `domain/repositories/`
- [ ] DTOs with `@freezed` + `fromJson` + `toDomain()`
- [ ] Data source class
- [ ] Repository implementation
- [ ] Sub-barrel files in each subfolder (`entities.dart`, `repositories.dart`, `models.dart`, `datasources.dart`, `controllers.dart`, `pages.dart`, `widgets.dart`)
- [ ] Layer barrel files: `domain.dart`, `data.dart`, `presentation.dart` (re-export sub-barrels)
- [ ] Provider file in `presentation/controllers/`
- [ ] Controller(s) with `@riverpod`
- [ ] Page(s) using `ConsumerWidget` / `ConsumerStatefulWidget`
- [ ] Route added to `AppRoute` enum and `app_router.dart`
- [ ] Translation keys in both `en.i18n.json` and `ru.i18n.json`, `make translations` executed
- [ ] `make gen` executed after each layer (domain, data, presentation)
- [ ] `make analyze` passes with no warnings
- [ ] `make format` applied
- [ ] `make gen` executed, generated files committed
- [ ] Tests written
