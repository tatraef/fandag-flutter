import 'package:fandag/core/inspector/inspector_initializer.dart';
import 'package:fandag/core/utils/debug_print.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int _maxValueLength = 300;

/// [ProviderObserver] that routes Riverpod lifecycle events to MadInspector.
///
/// Uses the provider name as the tag so each provider gets its own
/// section in the inspector's log viewer for easy filtering.
///
/// Only active when [isTestBuild] is true (zero-cost in release).
final class RiverpodObserver extends ProviderObserver {
  const RiverpodObserver();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (!isTestBuild) return;

    debugPublicPrint(
      '+ CREATED | value: ${_formatValue(value)}',
      tag: _providerName(context),
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (!isTestBuild) return;

    debugPublicPrint(
      '~ UPDATED\n'
      '  previous: ${_formatValue(previousValue)}\n'
      '  new: ${_formatValue(newValue)}',
      tag: _providerName(context),
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    if (!isTestBuild) return;

    debugPublicPrint('- DISPOSED', tag: _providerName(context));
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    if (!isTestBuild) return;

    debugPublicPrintLogger(
      '! ERROR',
      tag: _providerName(context),
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void mutationStart(
    ProviderObserverContext context,
    Mutation<Object?> mutation,
  ) {
    if (!isTestBuild) return;

    debugPublicPrint(
      '>> MUTATION START (${mutation.label})',
      tag: _providerName(context),
    );
  }

  @override
  void mutationSuccess(
    ProviderObserverContext context,
    Mutation<Object?> mutation,
    Object? result,
  ) {
    if (!isTestBuild) return;

    debugPublicPrint(
      '<< MUTATION SUCCESS (${mutation.label})',
      tag: _providerName(context),
    );
  }

  @override
  void mutationError(
    ProviderObserverContext context,
    Mutation<Object?> mutation,
    Object error,
    StackTrace stackTrace,
  ) {
    if (!isTestBuild) return;

    debugPublicPrintLogger(
      '!! MUTATION ERROR (${mutation.label})',
      tag: _providerName(context),
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void mutationReset(
    ProviderObserverContext context,
    Mutation<Object?> mutation,
  ) {
    if (!isTestBuild) return;

    debugPublicPrint(
      '<> MUTATION RESET (${mutation.label})',
      tag: _providerName(context),
    );
  }

  String _providerName(ProviderObserverContext context) =>
      context.provider.name ?? context.provider.runtimeType.toString();

  String _formatValue(Object? value) {
    final String str = value.toString();
    if (str.length <= _maxValueLength) return str;

    return '${str.substring(0, _maxValueLength)}...';
  }
}
