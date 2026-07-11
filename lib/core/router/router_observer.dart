import 'package:fandag/core/inspector/inspector.dart';
import 'package:fandag/core/utils/debug_print.dart';
import 'package:flutter/material.dart';

const String _tag = 'Router';

/// [NavigatorObserver] that routes navigation events to MadInspector.
///
/// Logs push, pop, replace, and remove events under the 'Router' tag
/// in the inspector's log viewer.
///
/// Only active when [isTestBuild] is true (zero-cost in release).
final class RouterObserver extends NavigatorObserver {
  RouterObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!isTestBuild) return;

    debugPublicPrint(
      '>> PUSH ${_routeName(route)} | from: ${_routeName(previousRoute)}',
      tag: _tag,
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!isTestBuild) return;

    debugPublicPrint(
      '<< POP ${_routeName(route)} | back to: ${_routeName(previousRoute)}',
      tag: _tag,
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (!isTestBuild) return;

    debugPublicPrint(
      '~ REPLACE ${_routeName(oldRoute)} -> ${_routeName(newRoute)}',
      tag: _tag,
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!isTestBuild) return;

    debugPublicPrint('- REMOVE ${_routeName(route)}', tag: _tag);
  }

  String _routeName(Route<dynamic>? route) => route?.settings.name ?? 'unknown';
}
