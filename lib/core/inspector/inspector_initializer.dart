import 'package:fandag/core/app/app_reloader.dart';
import 'package:fandag/core/exceptions/app_exception.dart';
import 'package:fandag/core/inspector/server_config.dart';
import 'package:fandag/core/utils/debug_print.dart';
import 'package:flutter/material.dart';
import 'package:mad_inspector/mad_inspector.dart';
import 'package:mad_inspector_debug_menu/mad_inspector_debug_menu.dart';
import 'package:mad_inspector_dio/mad_inspector_dio.dart';
import 'package:mad_inspector_server_selection/mad_inspector_server_selection.dart';

/// Whether this is a test/debug build (enables dev servers in server selection).
const bool isTestBuild = bool.fromEnvironment(
  'mb.isTestBuild',
  defaultValue: true,
);

/// Whether Mad Inspector should run in debug mode (enables inspector UI).
const bool isInspectorOnDebugMode = bool.fromEnvironment(
  'mb.isInspectorOnDebugMode',
  defaultValue: true,
);

/// Initialize Mad Inspector debugging toolkit.
///
/// Must be called before [ProviderScope] in main.dart to ensure
/// the Dio interceptor is available when Dio is created.
///
/// In release mode, initializes with [MadMode.release] which disables
/// all inspector functionality.
Future<void> initMadInspector() async {
  await MadInspector.I.init(
    mode: isInspectorOnDebugMode ? MadMode.debug : MadMode.release,
  );

  MadInspector.I.addModules(<MadModule>[
    MadDioModule.module,
    MadDebugMenuModule.module,
    MadServerSelectionModule.module(ServerConfig.servers, runOnRelease: true),
  ]);

  // Add default app logger for log viewing
  const String appLoggerName = 'appLogger';
  MadInspector.I.addLogger(MadLogger(name: appLoggerName));
  final LogBase? appLogger = MadInspector.I.getLogger(appLoggerName);

  printZoneErrorLogger = (AppException error, StackTrace stackTrace) {
    appLogger?.warning(
      'Exception caught ${error.runtimeType.toString()}',
      stackTrace: stackTrace,
      error: error.toString(),
    );
  };

  debugPublicPrintLogger =
      (String? message, {String? tag, Object? error, StackTrace? stackTrace}) {
        late final LogBase? currentLogger;

        if (tag == null) {
          currentLogger = appLogger;
        } else {
          LogBase? taggedLogger = MadInspector.I.getLogger(tag);
          if (taggedLogger == null) {
            MadInspector.I.addLogger(MadLogger(name: tag));
            taggedLogger = MadInspector.I.getLogger(tag);
          }
          currentLogger = taggedLogger;
        }

        final bool isError = error != null;
        if (isError) {
          currentLogger?.warning(
            message.toString(),
            error: error,
            stackTrace: stackTrace,
          );

          return;
        }

        final bool isTracing = stackTrace != null;
        if (isTracing) {
          currentLogger?.finest(message.toString(), stackTrace: stackTrace);

          return;
        }

        currentLogger?.info(message.toString());
      };

  // Initialize debug menu with standard actions
  if (isInspectorOnDebugMode) {
    MadDebugMenuModule.reloadApplicationFunction = (BuildContext context) {
      AppReloader.reload(context);
    };

    MadDebugMenuModule.init(
      buttons: const <Widget>[ReloadApplicationButton(), SystemInfoWidget()],
      values: const <Widget>[],
    );
  }
}
