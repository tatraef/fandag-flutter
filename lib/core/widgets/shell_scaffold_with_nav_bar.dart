import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell scaffold with bottom navigation bar for tab-based navigation.
class ShellScaffoldWithNavBar extends StatelessWidget {
  /// Creates a [ShellScaffoldWithNavBar].
  const ShellScaffoldWithNavBar({required this.navigationShell, super.key});

  /// The navigation shell managing the tab state.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.terrain_outlined),
            activeIcon: const Icon(Icons.terrain),
            label: context.t.navigation.hikes,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_outline),
            activeIcon: const Icon(Icons.favorite),
            label: context.t.navigation.favorites,
          ),
        ],
      ),
    );
  }
}
