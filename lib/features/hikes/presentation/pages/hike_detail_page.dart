import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:fandag/core/utils/date_formatting.dart';
import 'package:fandag/core/utils/launcher.dart';
import 'package:fandag/features/favorites/presentation/widgets/widgets.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/controllers/controllers.dart';
import 'package:fandag/features/hikes/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HikeDetailPage extends ConsumerWidget {
  const HikeDetailPage({required this.hikeId, super.key});

  final int hikeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Hike> hikeAsync = ref.watch(hikeDetailProvider(hikeId));

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FavoriteButton(
            hikeId: hikeId,
            unfilledColor: context.colors.textPrimary,
          ),
        ],
      ),
      body: hikeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace _) => _DetailError(
          onRetry: () => ref.invalidate(hikeDetailProvider(hikeId)),
        ),
        data: (Hike hike) => _DetailContent(hike: hike),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.hike});

  final Hike hike;

  static const double _padding = 16;
  static const double _gap = 12;
  static const double _sectionGap = 24;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _Gallery(images: hike.images),
        Padding(
          padding: const EdgeInsets.all(_padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(hike.title, style: context.primaryFonts.bold24),
              const SizedBox(height: _gap),
              Row(
                children: <Widget>[
                  if (hike.difficulty != null) ...<Widget>[
                    DifficultyBadge(difficulty: hike.difficulty!),
                    const SizedBox(width: _gap),
                  ],
                  Text(
                    DateFormatting.formatHikeDate(hike.dateStart, hike.dateEnd),
                    style: context.primaryFonts.regular16.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _sectionGap),
              _ParametersSection(hike: hike),
              if (hike.description != null) ...<Widget>[
                const SizedBox(height: _sectionGap),
                Text(
                  hike.description!,
                  style: context.primaryFonts.regular16.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
              if (hike.requirements.isNotEmpty) ...<Widget>[
                const SizedBox(height: _sectionGap),
                _BulletSection(
                  title: context.t.detail.requirements,
                  items: hike.requirements,
                ),
              ],
              if (hike.includes.isNotEmpty) ...<Widget>[
                const SizedBox(height: _sectionGap),
                _BulletSection(
                  title: context.t.detail.includes,
                  items: hike.includes,
                ),
              ],
              const SizedBox(height: _sectionGap),
              _OrganizerSection(hike: hike),
            ],
          ),
        ),
      ],
    );
  }
}

class _Gallery extends StatefulWidget {
  const _Gallery({required this.images});

  final List<String> images;

  static const double _height = 260;

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  final PageController _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return const SizedBox(height: _Gallery._height, child: HikeImage());
    }

    return SizedBox(
      height: _Gallery._height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (int index) => setState(() => _current = index),
            itemBuilder: (BuildContext context, int index) =>
                HikeImage(url: widget.images[index]),
          ),
          if (widget.images.length > 1)
            Padding(
              padding: const EdgeInsets.all(8),
              child: _Dots(count: widget.images.length, current: _current),
            ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(count, (int index) {
        final bool isActive = index == current;

        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? context.colors.accent : context.colors.textInverse,
          ),
        );
      }),
    );
  }
}

class _ParametersSection extends StatelessWidget {
  const _ParametersSection({required this.hike});

  final Hike hike;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = <Widget>[
      if (hike.price != null)
        _ParamRow(
          icon: Icons.payments_outlined,
          label: context.t.detail.price,
          value: '${hike.price} ${context.t.units.rub}',
        ),
      if (hike.distanceKm != null)
        _ParamRow(
          icon: Icons.route_outlined,
          label: context.t.detail.distance,
          value: '${_trim(hike.distanceKm!)} ${context.t.units.km}',
        ),
      if (hike.elevationGainM != null)
        _ParamRow(
          icon: Icons.trending_up,
          label: context.t.detail.elevation,
          value: '${hike.elevationGainM} ${context.t.units.m}',
        ),
      if (hike.departureTime != null)
        _ParamRow(
          icon: Icons.schedule,
          label: context.t.detail.departureTime,
          value: hike.departureTime!,
        ),
      if (hike.departurePlace != null)
        _ParamRow(
          icon: Icons.place_outlined,
          label: context.t.detail.departurePlace,
          value: hike.departurePlace!,
        ),
      if (hike.spotsLeft != null)
        _ParamRow(
          icon: Icons.event_seat_outlined,
          label: context.t.detail.spotsLeft,
          value: '${hike.spotsLeft}',
          highlight: true,
        ),
      if (hike.region != null)
        _ParamRow(
          icon: Icons.map_outlined,
          label: context.t.detail.region,
          value: hike.region!,
        ),
    ];

    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.t.detail.parameters, style: context.primaryFonts.semibold18),
        const SizedBox(height: 12),
        ...rows,
      ],
    );
  }

  String _trim(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';
}

class _ParamRow extends StatelessWidget {
  const _ParamRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final Color valueColor =
        highlight ? context.colors.warning : context.colors.textPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: context.colors.textTertiary),
          const SizedBox(width: 12),
          Text(
            label,
            style: context.primaryFonts.regular14.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: (highlight
                      ? context.primaryFonts.semibold16
                      : context.primaryFonts.medium14)
                  .copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: context.primaryFonts.semibold18),
        const SizedBox(height: 8),
        ...items.map(
          (String item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('•  ', style: context.primaryFonts.regular16),
                Expanded(
                  child: Text(item, style: context.primaryFonts.regular16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrganizerSection extends StatelessWidget {
  const _OrganizerSection({required this.hike});

  final Hike hike;

  @override
  Widget build(BuildContext context) {
    final Organizer organizer = hike.organizer;
    final String? phone = hike.contactPhone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(context.t.detail.organizer, style: context.primaryFonts.semibold18),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            title: Text(organizer.name, style: context.primaryFonts.semibold16),
            subtitle: organizer.city != null ? Text(organizer.city!) : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/organizer/${organizer.id}'),
          ),
        ),
        if (hike.contactName != null || phone != null) ...<Widget>[
          const SizedBox(height: 12),
          Text(
            <String?>[hike.contactName, phone]
                .whereType<String>()
                .join(' · '),
            style: context.primaryFonts.regular14.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (phone != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Launcher.call(phone),
              icon: const Icon(Icons.call),
              label: Text(context.t.detail.call),
            ),
          ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Launcher.openExternal(hike.sourceUrl),
            icon: const Icon(Icons.open_in_new),
            label: Text(context.t.detail.openOriginal),
          ),
        ),
      ],
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              context.t.detail.loadError,
              textAlign: TextAlign.center,
              style: context.primaryFonts.regular16,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(context.t.common.retry),
            ),
          ],
        ),
      ),
    );
  }
}
