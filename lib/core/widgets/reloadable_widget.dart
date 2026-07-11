import 'package:flutter/material.dart';

/// Reloads widgets when [reloadWidget] is called by changing [UniqueKey].
///
/// This widget wraps the app root and provides a mechanism to force a complete
/// widget tree rebuild without hot restart. When [reloadWidget] is called,
/// it generates a new [UniqueKey], causing Flutter to treat the subtree as
/// entirely new and rebuild it from scratch.
///
/// **Usage:**
/// ```dart
/// // In main.dart
/// runApp(
///   ReloadableWidget(
///     builder: (context) => const RootApp(),
///   ),
/// );
///
/// // To trigger reload from anywhere with BuildContext
/// ReloadableWidget.reloadWidget(context);
/// // or using extension
/// context.reloadWidget();
/// ```
class ReloadableWidget extends StatefulWidget {
  const ReloadableWidget({required this.builder, super.key});

  /// Builder function that creates the child widget.
  final WidgetBuilder builder;

  /// Triggers a widget tree rebuild by finding the nearest [ReloadableWidget]
  /// ancestor and calling its [reloadWidget] method.
  ///
  /// Returns `true` if a [ReloadableWidget] was found and reloaded,
  /// `false` otherwise.
  static bool reloadWidget(BuildContext context) {
    final _ReloadableWidgetState? state = context
        .findAncestorStateOfType<_ReloadableWidgetState>();
    if (state != null) {
      state.reloadWidget();

      return true;
    }

    return false;
  }

  /// Captures the reload function for use after async operations.
  ///
  /// This avoids using [BuildContext] across async gaps by capturing
  /// the state reference before any async work is done.
  ///
  /// Returns `null` if no [ReloadableWidget] is found in the widget tree.
  ///
  /// **Usage:**
  /// ```dart
  /// final reload = ReloadableWidget.captureReloadFunction(context);
  /// if (reload == null) return;
  ///
  /// await someAsyncOperation();
  /// reload(); // Safe - no BuildContext used
  /// ```
  static VoidCallback? captureReloadFunction(BuildContext context) {
    final _ReloadableWidgetState? state = context
        .findAncestorStateOfType<_ReloadableWidgetState>();
    if (state != null) {
      return state.reloadWidget;
    }

    return null;
  }

  @override
  State<ReloadableWidget> createState() => _ReloadableWidgetState();
}

class _ReloadableWidgetState extends State<ReloadableWidget> {
  Key _key = UniqueKey();

  /// Regenerates the key to force a complete rebuild of the child widget tree.
  void reloadWidget() {
    setState(() => _key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.builder(context));
  }
}

/// Extension on [BuildContext] for convenient widget reload.
extension ReloadableWidgetX on BuildContext {
  /// Triggers a widget tree rebuild by finding the nearest [ReloadableWidget]
  /// ancestor and calling its reload method.
  ///
  /// Returns `true` if a [ReloadableWidget] was found and reloaded,
  /// `false` otherwise.
  bool reloadWidget() => ReloadableWidget.reloadWidget(this);
}
