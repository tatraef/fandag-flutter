import 'dart:developer' as d;

import 'package:fandag/core/exceptions/app_exception.dart';
import 'package:fandag/core/inspector/inspector.dart';
import 'package:flutter/foundation.dart';

typedef LogMessage = void Function(String);

LogMessage createTaggedLogger(String tag) =>
    (String message) => debugPublicPrint(message, tag: tag);

void _printThrottled(String? message, {int? wrapWidth}) {
  final RegExp pattern = RegExp('.{1,$wrapWidth}');
  pattern
      .allMatches(message ?? '')
      .forEach(
        // ignore: avoid_print
        (RegExpMatch match) => print(match.group(0)),
      );
}

void debugPrint(
  String? message, {
  String? tag = 'debug-log',
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!isTestBuild) return;

  if (kReleaseMode) {
    _printThrottled('$tag: $message\n$error\n$stackTrace', wrapWidth: 800);

    return;
  }

  d.log(message ?? '', name: tag ?? '', error: error, stackTrace: stackTrace);
}

typedef DebugPublicPrintCallback =
    void Function(
      String? message, {
      String? tag,
      Object? error,
      StackTrace? stackTrace,
    });

DebugPublicPrintCallback debugPublicPrintLogger = debugPrint;

void debugPublicPrint(Object? message, {String? tag}) {
  if (!isTestBuild) return;

  debugPublicPrintLogger(message?.toString(), tag: tag);
}

void _printZoneError(AppException error, StackTrace stackTrace) {
  if (!isTestBuild) return;

  d.log(
    'Exception caught ${error.runtimeType.toString()}',
    name: 'Zone',
    stackTrace: stackTrace,
    error: error.toString(),
  );
}

typedef PrintZoneErrorCallback =
    void Function(AppException error, StackTrace stackTrace);

PrintZoneErrorCallback printZoneErrorLogger = _printZoneError;

void printFlutterError(String message, Object error, StackTrace? stackTrace) {
  if (!isTestBuild) return;

  debugPublicPrintLogger(
    message,
    tag: 'Flutter',
    stackTrace: stackTrace,
    error: error.toString(),
  );
}

void printCaughtError(AppException error, StackTrace stackTrace) {
  if (!isTestBuild) return;

  debugPublicPrintLogger(
    'Caught error ${error.runtimeType.toString()}',
    tag: 'Caught',
    stackTrace: stackTrace,
    error: error.toString(),
  );
}
