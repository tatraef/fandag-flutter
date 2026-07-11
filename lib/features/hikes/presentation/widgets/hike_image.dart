import 'package:cached_network_image/cached_network_image.dart';
import 'package:fandag/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Hike photo with a gradient/mountain placeholder for missing or failing URLs.
class HikeImage extends StatelessWidget {
  const HikeImage({this.url, this.fit = BoxFit.cover, super.key});

  final String? url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final String? url = this.url;

    if (url == null || url.isEmpty) {
      return const _Placeholder();
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (BuildContext context, String url) => const _Placeholder(),
      errorWidget: (BuildContext context, String url, Object error) =>
          const _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  static const double _iconSize = 48;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            context.colors.surfaceSecondary,
            context.colors.border,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.terrain_outlined,
          size: _iconSize,
          color: context.colors.textTertiary,
        ),
      ),
    );
  }
}
