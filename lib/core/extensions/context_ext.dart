import 'package:fandag/core/network/api_exception.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Maps an [Exception] to a user-friendly localized error message.
  ///
  /// Uses [ApiException] subtypes for specific messages,
  /// falls back to [common.errors.unknown] for unrecognized exceptions.
  String localizedErrorMessage(Exception exception) {
    final TranslationsCommonErrorsEn errors = t.common.errors;

    return switch (exception) {
      NetworkException() => errors.network,
      UnauthorizedException() => errors.unauthorized,
      TimeoutException() => errors.timeout,
      ServerException() => errors.server,
      ApiException(:final String? message) => message ?? errors.unknown,
      _ => errors.unknown,
    };
  }
}
