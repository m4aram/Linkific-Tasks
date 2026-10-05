import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text(
                'Flutter Package Explorer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _item(
              context,
              title: 'Home',
              icon: Icons.home_outlined,
              route: '/',
            ),
            _item(
              context,
              title: 'GetX',
              icon: Icons.bolt_outlined,
              route: '/getx',
            ),
            _item(
              context,
              title: 'Freezed',
              icon: Icons.data_object,
              route: '/freezed',
            ),
            _item(
              context,
              title: 'GoRouter',
              icon: Icons.route,
              route: '/router',
            ),
            _item(
              context,
              title: 'Dio',
              icon: Icons.cloud_outlined,
              route: '/dio',
            ),
            _item(
              context,
              title: 'Hive',
              icon: Icons.storage_outlined,
              route: '/hive',
            ),
            _item(
              context,
              title: 'Utilities',
              icon: Icons.extension_outlined,
              route: '/utilities',
            ),
            _item(
              context,
              title: 'Package Comparison',
              icon: Icons.compare_arrows,
              route: '/comparison',
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: currentRoute == route,
      onTap: () {
        Navigator.of(context).pop();
        if (currentRoute == route) {
          return;
        }

        Navigator.of(context).pushReplacementNamed(route);
      },
    );
  }
}
