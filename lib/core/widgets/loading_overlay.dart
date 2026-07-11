import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
  });

  final bool isLoading;
  final Widget child;

  static const double _overlayOpacity = 0.5;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: _overlayOpacity),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
