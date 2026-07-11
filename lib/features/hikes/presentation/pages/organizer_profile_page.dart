import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/controllers/controllers.dart';
import 'package:fandag/features/hikes/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrganizerProfilePage extends ConsumerWidget {
  const OrganizerProfilePage({required this.organizerId, super.key});

  final int organizerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Organizer> organizerAsync = ref.watch(
      organizerProfileProvider(organizerId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(organizerAsync.value?.name ?? '')),
      body: organizerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace _) => _OrganizerError(
          onRetry: () => ref.invalidate(organizerProfileProvider(organizerId)),
        ),
        data: (Organizer organizer) => _OrganizerContent(organizer: organizer),
      ),
    );
  }
}

class _OrganizerContent extends StatelessWidget {
  const _OrganizerContent({required this.organizer});

  final Organizer organizer;

  static const double _padding = 16;

  @override
  Widget build(BuildContext context) {
    final List<Hike> hikes = organizer.hikes ?? const <Hike>[];

    return ListView(
      padding: const EdgeInsets.all(_padding),
      children: <Widget>[
        Text(organizer.name, style: context.primaryFonts.bold24),
        if (organizer.city != null) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            organizer.city!,
            style: context.primaryFonts.regular16.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 24),
        Text(
          context.t.organizer.upcomingHikes,
          style: context.primaryFonts.semibold18,
        ),
        const SizedBox(height: 12),
        ...hikes.map(
          (Hike hike) => HikeCard(
            hike: hike,
            onTap: () => context.push('/hike/${hike.id}'),
          ),
        ),
      ],
    );
  }
}

class _OrganizerError extends StatelessWidget {
  const _OrganizerError({required this.onRetry});

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
              context.t.organizer.loadError,
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
