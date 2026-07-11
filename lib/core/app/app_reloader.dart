import 'package:fandag/core/inspector/inspector.dart';
import 'package:fandag/core/router/router.dart';
import 'package:fandag/core/utils/debug_print.dart';
import 'package:fandag/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Manages full application reload with dependency re-initialization.
///
/// In Riverpod architecture, there is no GetIt container to reset.
/// Instead, the [ReloadableWidget] triggers a full widget tree rebuild,
/// which causes [ProviderScope] to be recreated — effectively resetting
/// all providers.
///
/// **Usage:**
/// ```dart
/// // From any widget with BuildContext
/// await AppReloader.reload(context);
/// ```
///
/// **What gets reset:**
/// - All Riverpod providers (ProviderScope is recreated)
/// - Navigation state (rootNavigatorKey is recreated)
/// - Mad Inspector state (re-initialized before rebuild)
///
/// **What gets preserved:**
/// - Zone error handling (at runZonedGuarded level)
class AppReloader {
  AppReloader._();

  /// Reloads the application.
  ///
  /// 1. Captures ReloadableWidget state reference (before async operations)
  /// 2. Re-initializes Mad Inspector
  /// 3. Recreates navigator key to reset navigation state
  /// 4. Triggers widget tree rebuild (recreates ProviderScope)
  ///
  /// Returns `true` if reload was successful, `false` if [ReloadableWidget]
  /// was not found in the widget tree.
  static Future<bool> reload(BuildContext context) async {
    debugPublicPrintLogger('Starting app reload...', tag: 'AppReloader');

    // Capture the reload function before async gap
    final VoidCallback? reloadFunction = ReloadableWidget.captureReloadFunction(
      context,
    );
    if (reloadFunction == null) {
      debugPublicPrintLogger(
        'Warning: ReloadableWidget not found in widget tree',
        tag: 'AppReloader',
      );

      return false;
    }

    // Re-initialize Mad Inspector
    await initMadInspector();

    // Recreate navigator key so new GoRouter starts with fresh navigation
    rootNavigatorKey = GlobalKey<NavigatorState>();

    // Rebuild widget tree using captured function
    reloadFunction();
    debugPublicPrintLogger('App reload complete', tag: 'AppReloader');

    return true;
  }
}
