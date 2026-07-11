import 'package:fandag/core/app/app_reloader.dart';
import 'package:fandag/core/utils/debug_print.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Debug action to clear all SharedPreferences.
///
/// Useful for testing authentication flows and resetting app state.
Future<void> clearPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  debugPublicPrintLogger('[DebugAction] SharedPreferences cleared');
}

/// Debug action to reload the application.
///
/// Triggers widget tree rebuild via [ReloadableWidget], which recreates
/// the [ProviderScope] and resets all providers.
/// Useful for testing changes without hot restart.
Future<void> reloadApplication(BuildContext context) async {
  debugPublicPrintLogger('[DebugAction] Application reload requested');
  await AppReloader.reload(context);
}
