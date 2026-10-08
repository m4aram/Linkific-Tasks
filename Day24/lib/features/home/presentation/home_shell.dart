import 'package:flutter/material.dart';
import 'package:shoplite/core/constants/app_strings.dart';
import 'package:shoplite/features/favorites/presentation/favorites_screen.dart';
import 'package:shoplite/features/products/presentation/products_screen.dart';
import 'package:shoplite/features/profile/presentation/profile_screen.dart';

/// Bottom-navigation shell.
///
/// * `IndexedStack` keeps each tab alive, so switching tabs does not
///   rebuild it or lose its scroll position.
/// * Tabs are created lazily: a tab is built the first time it is
///   opened, not at startup.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const List<Widget> _tabs = [
    ProductsScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  int _index = 0;
  final Set<int> _openedTabs = {0};

  void _onDestinationSelected(int index) {
    if (index == _index) return;
    setState(() {
      _index = index;
      _openedTabs.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          for (var i = 0; i < _tabs.length; i++)
            _openedTabs.contains(i) ? _tabs[i] : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: AppStrings.tabProducts,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: AppStrings.tabFavorites,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppStrings.tabProfile,
          ),
        ],
      ),
    );
  }
}
