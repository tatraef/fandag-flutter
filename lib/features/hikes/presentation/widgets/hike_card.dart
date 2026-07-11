import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:fandag/core/utils/date_formatting.dart';
import 'package:fandag/features/favorites/presentation/widgets/widgets.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/widgets/difficulty_badge.dart';
import 'package:fandag/features/hikes/presentation/widgets/hike_image.dart';
import 'package:flutter/material.dart';

/// Feed card for a single hike. Used in the feed, organizer profile and
/// favorites lists.
class HikeCard extends StatelessWidget {
  const HikeCard({required this.hike, required this.onTap, super.key});

  final Hike hike;
  final VoidCallback onTap;

  static const double _imageAspectRatio = 16 / 9;
  static const double _padding = 12;
  static const double _gap = 6;
  static const double _bottomMargin = 12;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: _bottomMargin),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _ImageHeader(hike: hike),
            Padding(
              padding: const EdgeInsets.all(_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(hike.title, style: context.primaryFonts.semibold16),
                  const SizedBox(height: _gap),
                  Row(
                    children: <Widget>[
                      Text(
                        DateFormatting.formatHikeDate(
                          hike.dateStart,
                          hike.dateEnd,
                        ),
                        style: context.primaryFonts.regular14.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      if (hike.difficulty != null) ...<Widget>[
                        const SizedBox(width: _gap),
                        DifficultyBadge(difficulty: hike.difficulty!),
                      ],
                    ],
                  ),
                  if (hike.price != null) ...<Widget>[
                    const SizedBox(height: _gap),
                    Text(
                      '${hike.price} ${context.t.units.rub}',
                      style: context.primaryFonts.semibold16.copyWith(
                        color: context.colors.accent,
                      ),
                    ),
                  ],
                  const SizedBox(height: _gap),
                  _Subtitle(hike: hike),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({required this.hike});

  final Hike hike;

  static const double _aspectRatio = HikeCard._imageAspectRatio;
  static const double _favoriteInset = 4;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: _aspectRatio,
          child: HikeImage(
            url: hike.images.length > 1
                ? hike.images[1]
                : hike.images.isNotEmpty
                    ? hike.images.first
                    : null,
          ),
        ),
        Positioned(
          top: _favoriteInset,
          right: _favoriteInset,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.black26,
              shape: BoxShape.circle,
            ),
            child: FavoriteButton(hikeId: hike.id),
          ),
        ),
      ],
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.hike});

  final Hike hike;

  @override
  Widget build(BuildContext context) {
    final String? region = hike.region;
    final String text = region != null
        ? '${hike.organizer.name} · $region'
        : hike.organizer.name;

    return Text(
      text,
      style: context.primaryFonts.regular12.copyWith(
        color: context.colors.textTertiary,
      ),
    );
  }
}
