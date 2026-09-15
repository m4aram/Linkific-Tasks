import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Welcome'),
          content: const Text(
            'This dashboard demonstrates Material 3 cards, dialogs, buttons, and navigation.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showSimpleDialogMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Choose an option'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Profile'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Settings'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Help'),
            ),
          ],
        );
      },
    );
  }

  void showMaterialBanner(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('Welcome to Material Design App'),
        leading: const Icon(Icons.info_outline),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('DISMISS'),
          ),
        ],
      ),
    );
  }

  void showBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Action completed successfully'),
        action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userName = arguments?['name'] ?? 'Guest';
    final userEmail = arguments?['email'] ?? 'No email provided';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              showInfoDialog(context);
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, $userName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(userEmail),

            const SizedBox(height: 20),

            const Text(
              'Overview',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.people)),
                title: Text('Total Users'),
                subtitle: Text('1,250 registered users'),
                trailing: Icon(Icons.trending_up),
              ),
            ),

            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.shopping_cart)),
                title: Text('Total Orders'),
                subtitle: Text('320 completed orders'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),

            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.analytics)),
                title: Text('Revenue'),
                subtitle: Text('\$8,450 total revenue'),
                trailing: Icon(Icons.attach_money),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/form',
                  arguments: {
                    'source': 'Dashboard',
                    'title': 'New Task',
                    'name': userName,
                    'email': userEmail,
                  },
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Open Form'),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                showInfoDialog(context);
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Show AlertDialog'),
            ),

            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: () {
                showSnackBar(context);
              },
              icon: const Icon(Icons.check),
              label: const Text('Show SnackBar'),
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: () {
                showSimpleDialogMenu(context);
              },
              icon: const Icon(Icons.list),
              label: const Text('Show SimpleDialog'),
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: () {
                showMaterialBanner(context);
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Show MaterialBanner'),
            ),

            const SizedBox(height: 12),

            TextButton.icon(
              onPressed: () {
                showBottomSheetMenu(context);
              },
              icon: const Icon(Icons.menu),
              label: const Text('Open BottomSheet'),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button pressed')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
