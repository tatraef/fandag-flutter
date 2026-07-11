import 'package:fandag/core/inspector/inspector.dart';
import 'package:fandag/core/router/app_route.dart';
import 'package:fandag/core/router/router_observer.dart';
import 'package:fandag/core/widgets/widgets.dart';
import 'package:fandag/features/favorites/presentation/presentation.dart';
import 'package:fandag/features/hikes/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Navigator key used by GoRouter, exposed for [MadInspectorView] integration.
///
/// Recreated in [AppReloader.reload] to fully reset navigation state.
GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.hikes.path,
    observers: <NavigatorObserver>[if (isTestBuild) RouterObserver()],
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return ShellScaffoldWithNavBar(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.hikes.path,
                builder: (BuildContext context, GoRouterState state) =>
                    const HikesFeedPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.favorites.path,
                builder: (BuildContext context, GoRouterState state) =>
                    const FavoritesPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.hikeDetail.path,
        builder: (BuildContext context, GoRouterState state) {
          final int id = int.parse(state.pathParameters['id']!);

          return HikeDetailPage(hikeId: id);
        },
      ),
      GoRoute(
        path: AppRoute.organizer.path,
        builder: (BuildContext context, GoRouterState state) {
          final int id = int.parse(state.pathParameters['id']!);

          return OrganizerProfilePage(organizerId: id);
        },
      ),
    ],
  );
}
