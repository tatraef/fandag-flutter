---
name: widget-patterns
description: Reusable widget class patterns. Auto-loads when creating widgets or discussing UI components.
user-invocable: false
---

# Widget Patterns

Widgets are reusable UI components. Always widget **classes**, never widget-returning functions.

## Widget Types

```
Does the widget need Riverpod state?
├── Yes → ConsumerWidget or ConsumerStatefulWidget
└── No
    ├── Needs local state (animation, text controller)? → StatefulWidget
    └── Pure display? → StatelessWidget
```

## Canonical Template — StatelessWidget

```dart
import 'package:flutter/material.dart';
import 'package:flutter_template_v3/core/core.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    required this.title,
    required this.subtitle,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  static const double _cardPadding = 16;
  static const double _spacingSmall = 8;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: _spacingSmall),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(_cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: context.primaryFonts.semibold16,
              ),
              const SizedBox(height: _spacingSmall),
              Text(
                subtitle,
                style: context.primaryFonts.regular14.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Real Examples

### PostCard

```dart
// lib/features/home/presentation/widgets/post_card.dart
class PostCard extends StatelessWidget {
  const PostCard({required this.post, this.onDelete, super.key});

  final Post post;
  final VoidCallback? onDelete;

  static const double _cardPadding = 16;
  static const double _spacingSmall = 8;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: _spacingSmall),
      child: Padding(
        padding: const EdgeInsets.all(_cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    post.title,
                    style: context.primaryFonts.semibold16,
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: context.colors.error,
                    ),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: _spacingSmall),
            Text(
              post.body,
              style: context.primaryFonts.regular14.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### AuthFormField

```dart
// lib/features/auth/presentation/widgets/auth_form_field.dart
class AuthFormField extends StatelessWidget {
  const AuthFormField({
    required this.controller,
    required this.label,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  static const double _bottomPadding = 16;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _bottomPadding),
      child: AppTextField(
        controller: controller,
        label: label,
        errorText: errorText,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
```

## Rules

1. **Only widget classes** — `StatelessWidget`, `StatefulWidget`, `ConsumerWidget`, `ConsumerStatefulWidget`
2. **`const` constructors** — always
3. **`final` fields** — all constructor parameters
4. **Constructor first, `build()` last** — in class body
5. **`super.key`** — use `super.key` parameter, not `Key? key` in constructor
6. **Explicit types everywhere** — `always_specify_types` is enabled
7. **Single quotes** for strings
8. **Named constants** for dimensions and strings — no magic numbers
9. **`<Widget>[]`** — explicit type for children lists
10. **Theme access** via extensions: `context.colors`, `context.primaryFonts`

## Theme Access

```dart
// Colors
context.colors.primary
context.colors.textSecondary
context.colors.error
context.colors.background

// Typography
context.primaryFonts.semibold16
context.primaryFonts.regular14
context.primaryFonts.bold20

// Material theme
context.theme.textTheme.headlineMedium
context.theme.colorScheme.error

// Localization
context.t.feature.title
context.t.common.retry
```

## Barrel File

Add every new widget to the sub-barrel `widgets/widgets.dart`:

```dart
// presentation/widgets/widgets.dart
export 'post_card.dart';
export 'auth_form_field.dart';
```

## Anti-Patterns

```dart
// BAD: widget-returning function
Widget _buildHeader(BuildContext context) {
  return Text('Header');
}
// CORRECT: create a separate StatelessWidget class

// BAD: magic numbers
Padding(padding: EdgeInsets.all(16))
// CORRECT: static const double _padding = 16;
//          Padding(padding: EdgeInsets.all(_padding))

// BAD: inline styles
Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
// CORRECT: Text('Title', style: context.primaryFonts.semibold16)

// BAD: Key? key in constructor
const PostCard({Key? key}) : super(key: key);
// CORRECT: const PostCard({super.key});

// BAD: missing const on constructor
PostCard({required this.post, super.key});  // WRONG — missing const

// BAD: using relative imports
import '../../../domain/entities/post.dart';
// CORRECT: import 'package:flutter_template_v3/features/home/domain/domain.dart';
```
