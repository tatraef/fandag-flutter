import 'package:fandag/core/theme/theme.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  static const double _loaderSize = 20;
  static const double _loaderStrokeWidth = 2;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      child: isLoading
          ? SizedBox(
              width: _loaderSize,
              height: _loaderSize,
              child: CircularProgressIndicator(
                strokeWidth: _loaderStrokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.textInverse,
                ),
              ),
            )
          : Text(text),
    );
  }
}
