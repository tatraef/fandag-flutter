# What to Test — Flutter Template v3

This guide explains **what code should be tested** and **what can be skipped** to maximize testing ROI.

## The 80/20 Rule

**80% of testing value** comes from **20% of your tests**. Focus on:
- Business logic
- Error handling
- Data transformations
- Validation

## Priority Matrix

### 🔴 Tier 1: ALWAYS Test (Critical)

Code that **breaks the app** if wrong:

#### 1. Business Logic in Domain
```dart
// ✅ TEST - Complex calculation
class Order {
  Money calculateTotal() {
    return items.fold(Money.zero, (sum, item) =>
      sum + item.price * item.quantity
    ) + shippingCost;
  }

  bool canBeCancelled() {
    return status == OrderStatus.pending &&
           createdAt.add(Duration(hours: 24)).isAfter(DateTime.now());
  }
}

// ❌ SKIP - Simple data class
class User {
  final String id;
  final String name;
}
```

#### 2. Error Handling
```dart
// ✅ TEST - Error mapping
// Prefer testing centralized conversion, not per-repository mapping.
ApiException convert(Object error) {
  return ApiExceptionConverter.convert(error);
}
```

#### 3. Data Transformations
```dart
// ✅ TEST - Complex mapping
Post toDomain() {
  return Post(
    price: Money.fromCents(priceCents),  // Conversion
    status: OrderStatus.fromString(statusRaw),  // Parsing
    items: items?.map((e) => e.toDomain()).toList() ?? [],  // Nested
  );
}

// ❌ SKIP - Trivial 1-to-1 mapping
User toDomain() {
  return User(id: id, name: name);
}
```

#### 4. Input Validation
```dart
// ✅ TEST - Custom validation
extension StringExt {
  bool get isValidEmail {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(this);
  }
}
```

### 🟠 Tier 2: USUALLY Test (Important)

Code that **impacts UX** if wrong:

#### 5. Repository Implementations
```dart
// ✅ TEST - Repository mapping DTOs to domain and calling datasource
class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<Post>> getPosts() async {
    final dtos = await _dataSource.getPosts();

    return dtos.map((PostDto dto) => dto.toDomain()).toList();
  }
}
```

**Test:**
- Calls datasource correctly
- Maps DTOs to entities
- Propagates `ApiException` from datasource

#### 6. Controllers with State Management
```dart
// ✅ TEST - Complex state machine
class CheckoutController {
  Future<void> processPayment() async {
    state = const AsyncLoading();

    // 1. Validate
    if (!_validateForm()) {
      state = AsyncError(ValidationException());
      return;
    }

    // 2. Call API
    try {
      final result = await _repository.processPayment(...);
      state = AsyncData(result);

      // 3. Navigate
      _router.go('/success');
    } catch (e) {
      state = AsyncError(e);
    }
  }
}

// ⚠️ OPTIONAL - Simple proxy
class ListController {
  Future<List<Item>> build() => _repository.getItems();
}
```

#### 7. Core Utilities
```dart
// ✅ TEST - Complex utility
class DateFormatter {
  String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return DateFormat('MMM d, y').format(date);
  }
}
```

### 🟡 Tier 3: SOMETIMES Test (Helpful)

Code that's **nice to have** covered:

#### 8. Datasources
```dart
// ✅ TEST IF - Complex parsing
class DataSource {
  Future<List<PostDto>> getPosts() async {
    final response = await _apiClient.get('/posts');
    final data = response.data ?? [];

    // Complex parsing logic
    return data.map((json) {
      // Custom deserialization
      return PostDto.fromJson(_transformJson(json));
    }).toList();
  }
}

// ❌ SKIP IF - Simple API call
class DataSource {
  Future<List<PostDto>> getPosts() async {
    final response = await _apiClient.get('/posts');
    return (response.data as List).map((e) => PostDto.fromJson(e)).toList();
  }
}
```

#### 9. DTO Mapping
```dart
// ✅ TEST IF - Non-trivial
PostDto toDomain() {
  return Post(
    date: DateTime.parse(dateString),
    amount: double.parse(amountString),
    tags: tagsString?.split(',').map((e) => e.trim()).toList(),
  );
}

// ❌ SKIP IF - Simple
UserDto toDomain() {
  return User(id: id, name: name, email: email);
}
```

### ⚪ Tier 4: RARELY Test (Low Value)

#### 10. Widget Tests
```dart
// ⚠️ ONLY IF - Critical reusable component
testWidgets('form should validate on submit', (tester) async {
  // Test complex form behavior
});

// ❌ SKIP - Simple layout
testWidgets('page should have title', (tester) async {
  // Low value
});
```

### ❌ Tier 5: NEVER Test

#### Generated Code
```dart
// ❌ NEVER TEST
*.g.dart       // JSON serialization (tested by json_serializable)
*.freezed.dart // Freezed code (tested by freezed)
*.drift.dart   // Database code (tested by drift)
```

#### Trivial Code
```dart
// ❌ NEVER TEST
class User {
  String get displayName => name;  // Trivial getter

  void setName(String value) {     // Trivial setter
    _name = value;
  }
}
```

#### Framework/Library Code
```dart
// ❌ NEVER TEST
final dio = Dio();           // Don't test Dio
final router = GoRouter();   // Don't test GoRouter
Widget build() {             // Don't test Flutter framework
  return Scaffold(...);
}
```

#### Golden Tests
```dart
// ❌ NEVER USE - Too fragile
await expectLater(
  find.byType(MyWidget),
  matchesGoldenFile('widget.png'),  // Breaks on every Flutter update
);
```

## Decision Tree

```
Is it generated code?
├─ YES → ❌ Don't test
└─ NO → Does it have logic?
    ├─ NO → ❌ Don't test (trivial)
    └─ YES → Is it business logic?
        ├─ YES → ✅ MUST test (Tier 1)
        └─ NO → Is it error handling or validation?
            ├─ YES → ✅ MUST test (Tier 1)
            └─ NO → Is it data transformation?
                ├─ YES (complex) → ✅ SHOULD test (Tier 2)
                ├─ YES (simple) → ⚠️ MAYBE test (Tier 3)
                └─ NO → Is it a controller?
                    ├─ YES (complex) → ✅ SHOULD test (Tier 2)
                    ├─ YES (simple) → ⚠️ MAYBE test (Tier 3)
                    └─ NO → ⚪ LOW priority (Tier 4)
```

## Examples from Template

### ✅ What We Test

```
✅ User entity (has business logic? No, but baseline)
✅ Post entity (has business logic? No, but baseline)
✅ AuthTokens entity (baseline)
✅ UserDto → User mapping
✅ PostDto → Post mapping
✅ AuthTokensDto → AuthTokens mapping
✅ StringExt.isValidEmail (validation)
✅ ApiException hierarchy (error handling)
✅ DioProvider configuration
✅ SignInController (form validation)
```

### ❌ What We Don't Test

```
❌ Generated files (*.g.dart, *.freezed.dart)
❌ Simple barrel files
❌ MaterialApp setup
❌ Route configuration (just data)
❌ ThemeData (just data)
❌ Simple widgets (just layout)
❌ Trivial extensions (capitalize)
```

### ⚠️ What We Should Test (TODO)

```
⚠️ HomeRepositoryImpl (error mapping)
⚠️ AuthRepositoryImpl (error mapping)
⚠️ HomeRemoteDataSource (if complex parsing)
⚠️ HomeController (state management)
```

## Coverage Goals

| Layer | Goal | What to Cover |
|-------|------|---------------|
| **Domain** | 90%+ | All entities with logic, business rules |
| **Core** | 80%+ | Utilities, extensions, exceptions |
| **Data** | 70%+ | Complex DTOs, repository error mapping |
| **Presentation** | 30-50% | Complex controllers, validation |

## Quick Checklist

Before writing a test, ask:

1. **Is it generated code?** → ❌ Don't test
2. **Is it trivial (getter/data class)?** → ❌ Don't test
3. **Is it third-party code?** → ❌ Don't test
4. **Does it have business logic?** → ✅ MUST test
5. **Does it handle errors?** → ✅ MUST test
6. **Does it transform data?** → ✅ SHOULD test
7. **Does it validate input?** → ✅ MUST test
8. **Is it complex state management?** → ✅ SHOULD test
9. **Is it a simple proxy?** → ⚠️ MAYBE skip

## Anti-Patterns

### ❌ Over-Testing

```dart
// ❌ BAD - Testing Freezed
test('should have copyWith', () {
  final user = User(id: '1', name: 'Test');
  final updated = user.copyWith(name: 'Updated');
  expect(updated.name, 'Updated');
});
// This tests Freezed library, not your code!
```

### ❌ Testing Implementation

```dart
// ❌ BAD - Testing private method
test('_privateMethod should work', () {
  expect(myClass._privateMethod(), true);
});

// ✅ GOOD - Test public API
test('publicMethod should return expected result', () {
  expect(myClass.publicMethod(), expectedResult);
});
```

### ❌ Flaky Tests

```dart
// ❌ BAD - Time-dependent
test('should be recent', () {
  final now = DateTime.now();
  final user = User(createdAt: now);
  expect(user.isRecent, isTrue);  // May fail if test runs slow
});

// ✅ GOOD - Explicit time
test('should be recent when created within 1 hour', () {
  final time = DateTime(2024, 1, 1, 12, 0);
  final user = User(createdAt: time);
  expect(user.isRecentAt(DateTime(2024, 1, 1, 12, 30)), isTrue);
});
```

## Summary

**Focus testing effort on:**
1. 🔴 Business logic (domain)
2. 🔴 Error handling
3. 🔴 Data transformations
4. 🔴 Input validation
5. 🟠 Repository implementations
6. 🟠 Complex controllers

**Skip testing:**
- Generated code
- Trivial code
- Third-party libraries
- Golden tests
- Simple layout widgets

This gives you **maximum ROI** with **minimum maintenance**.
