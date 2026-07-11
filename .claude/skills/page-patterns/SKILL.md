---
name: page-patterns
description: Page widget patterns with ConsumerWidget, selective rebuilds, and AsyncValue. Auto-loads when creating pages, screens, or discussing UI layer.
user-invocable: false
---

# Page Patterns

Pages are top-level screens using `ConsumerWidget` or `ConsumerStatefulWidget`. They enforce **selective rebuilds** — page `build()` NEVER calls `ref.watch` directly.

## Decision: ConsumerWidget vs ConsumerStatefulWidget

```
Does the page need TextEditingController, AnimationController, or initState/dispose?
├── Yes → ConsumerStatefulWidget
└── No  → ConsumerWidget
```

---

## Pattern 1 — ConsumerWidget (simple pages, lists)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template_v3/core/core.dart';
import 'package:flutter_template_v3/features/<feature>/domain/domain.dart';
import 'package:flutter_template_v3/features/<feature>/presentation/controllers/controllers.dart';

class FeaturePage extends ConsumerWidget {
  const FeaturePage({super.key});

  static const double _horizontalPadding = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.<feature>.title)),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final AsyncValue<List<Entity>> state = ref.watch(
            featureControllerProvider,
          );

          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    context.t.common.errorOccurred,
                    style: context.theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: _horizontalPadding),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(featureControllerProvider.notifier).refresh(),
                    child: Text(context.t.common.retry),
                  ),
                ],
              ),
            ),
            data: (List<Entity> items) => ListView.builder(
              padding: const EdgeInsets.all(_horizontalPadding),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) =>
                  EntityCard(entity: items[index]),
            ),
          );
        },
      ),
    );
  }
}
```

### Real Example — HomePage

```dart
// lib/features/home/presentation/pages/home_page.dart
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const double _horizontalPadding = 16;
  static const double _topPadding = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.home.title),
        actions: <Widget>[
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final User? user = ref.watch(
                authStateControllerProvider.select(
                  (AsyncValue<AuthState> s) => s.value?.user,
                ),
              );

              if (user == null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(right: _horizontalPadding),
                child: Center(child: Text(user.name)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateControllerProvider.notifier).onSignedOut();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final AsyncValue<List<Post>> postsAsync = ref.watch(
            homeControllerProvider,
          );

          return postsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(context.t.common.errorOccurred),
                  const SizedBox(height: _topPadding),
                  ElevatedButton(
                    onPressed: () =>
                        ref.read(homeControllerProvider.notifier).refresh(),
                    child: Text(context.t.common.retry),
                  ),
                ],
              ),
            ),
            data: (List<Post> posts) {
              if (posts.isEmpty) {
                return Center(child: Text(context.t.home.noPosts));
              }

              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(homeControllerProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(_horizontalPadding),
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PostCard(
                      post: posts[index],
                      onDelete: () => ref
                          .read(homeControllerProvider.notifier)
                          .deletePost(posts[index].id),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## Pattern 2 — ConsumerStatefulWidget (forms)

```dart
class FeatureFormPage extends ConsumerStatefulWidget {
  const FeatureFormPage({super.key});

  @override
  ConsumerState<FeatureFormPage> createState() => _FeatureFormPageState();
}

class _FeatureFormPageState extends ConsumerState<FeatureFormPage> {
  final TextEditingController _fieldController = TextEditingController();

  static const double _horizontalPadding = 24;
  static const double _topSpacing = 80;

  @override
  void dispose() {
    _fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            children: <Widget>[
              const SizedBox(height: _topSpacing),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final String? fieldError = ref.watch(
                    featureControllerProvider.select(
                      (FeatureState s) => s.fieldError,
                    ),
                  );

                  return TextField(
                    controller: _fieldController,
                    decoration: InputDecoration(errorText: fieldError),
                    onChanged:
                        ref.read(featureControllerProvider.notifier).setField,
                  );
                },
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final bool isLoading = ref.watch(
                    featureControllerProvider.select(
                      (FeatureState s) => s.isLoading,
                    ),
                  );

                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : ref.read(featureControllerProvider.notifier).submit,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Real Example — SignInPage

```dart
// lib/features/auth/presentation/pages/sign_in_page.dart
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const double _horizontalPadding = 24;
  static const double _topSpacing = 80;
  static const double _titleBottomSpacing = 48;
  static const double _buttonTopSpacing = 24;
  static const double _linkTopSpacing = 16;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: _topSpacing),
              Text(
                context.t.auth.signIn,
                style: context.theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _titleBottomSpacing),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final String? emailError = ref.watch(
                    signInControllerProvider.select(
                      (SignInState s) => s.emailError,
                    ),
                  );

                  return AuthFormField(
                    controller: _emailController,
                    label: context.t.auth.email,
                    errorText: emailError,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged:
                        ref.read(signInControllerProvider.notifier).setEmail,
                  );
                },
              ),
              // ... password field, error message, submit button
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Key Rules

### Selective Rebuilds

Page `build()` must **NEVER** call `ref.watch` directly. Wrap state-dependent widgets in `Consumer`:

```dart
// CORRECT — selective rebuild
Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final Exception? error = ref.watch(
      controllerProvider.select((State s) => s.error),
    );
    if (error == null) {
      return const SizedBox.shrink();
    }
    // Only rebuilds when error changes
    return Text(context.localizedErrorMessage(error));
  },
)

// WRONG — rebuilds entire page on any state change
@override
Widget build(BuildContext context, WidgetRef ref) {
  final State state = ref.watch(controllerProvider);  // BAD!
  return Text(state.error?.toString() ?? '');
}
```

### Side-Effects with ref.listen

Use `ref.listen` for navigation, snackbars, dialogs — never `ref.watch`:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  ref.listen(controllerProvider.select((State s) => s.isSuccess), (_, bool isSuccess) {
    if (isSuccess) {
      context.go(AppRoute.home.path);
    }
  });

  return Scaffold(...);
}
```

### Callbacks with ref.read

Use `ref.read` in button callbacks, `onPressed`, `onChanged`:

```dart
ElevatedButton(
  onPressed: ref.read(controllerProvider.notifier).submit,  // ref.read, not ref.watch
  child: const Text('Submit'),
)
```

### Theme & Localization Access

```dart
context.colors.primary           // AppColors (from core/extensions)
context.primaryFonts.semibold16  // TextStyle (from core/extensions)
context.theme.textTheme          // Material theme (from core/extensions)
context.t.feature.title          // Translations (requires translations import)
```

Required imports for these:
```dart
import 'package:flutter_template_v3/core/extensions/extensions.dart'; // colors, primaryFonts, theme
import 'package:flutter_template_v3/core/translations/generated/translations.g.dart'; // context.t
```

For navigation with GoRouter:
```dart
import 'package:flutter_template_v3/core/router/router.dart'; // AppRoute
import 'package:go_router/go_router.dart'; // context.go()
```

### Layout

- Constructor first, `build()` always last
- Named constants for dimensions (no magic numbers)
- `const` wherever possible

## Anti-Patterns

```dart
// BAD: ref.watch in page build()
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(controllerProvider);  // Rebuilds ENTIRE page
  // ...
}

// BAD: widget functions instead of classes
Widget _buildHeader() { ... }  // WRONG — use a StatelessWidget class

// BAD: inline styles without constants
Padding(padding: EdgeInsets.all(16))  // WRONG — extract to named constant

// BAD: ref.watch in callbacks
onPressed: () => ref.watch(controllerProvider.notifier).submit()
// WRONG — use ref.read in callbacks
```
