import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Day 11 Permissions',
      theme: ThemeData(useMaterial3: true),
      home: const PermissionPage(),
    );
  }
}

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  final Map<Permission, String> permissionNames = {
    Permission.camera: 'Camera',
    Permission.microphone: 'Microphone',
    Permission.locationWhenInUse: 'Location',
    Permission.photos: 'Gallery / Photos',
    Permission.storage: 'Storage',
    Permission.contacts: 'Contacts',
  };
  Map<Permission, PermissionStatus> statuses = {};

  Future<void> requestPermission(Permission permission) async {
    final currentStatus = await permission.status;
    // Already granted
    if (currentStatus.isGranted) {
      _showMessage(
        '${permissionNames[permission]} permission is already granted.',
      );
      return;
    }

    // Permanently denied
    if (currentStatus.isPermanentlyDenied) {
      await _showPermanentlyDeniedDialog(permission);
      return;
    }

    // Show rationale before requesting
    final shouldContinue = await _showRationaleDialog(permission);

    if (!shouldContinue) return;

    final result = await permission.request();

    setState(() {
      statuses[permission] = result;
    });

    if (result.isGranted) {
      _showMessage('${permissionNames[permission]} permission granted.');
    } else if (result.isDenied) {
      _showMessage('${permissionNames[permission]} permission denied.');
    } else if (result.isPermanentlyDenied) {
      await _showPermanentlyDeniedDialog(permission);
    } else if (result.isRestricted) {
      _showMessage('${permissionNames[permission]} permission is restricted.');
    }
  }

  Future<void> requestAllPermissions() async {
    final permissions = permissionNames.keys.toList();
    for (final permission in permissions) {
      await requestPermission(permission);
    }
  }

  Future<bool> _showRationaleDialog(Permission permission) async {
    final name = permissionNames[permission] ?? 'This';
    final descriptions = {
      Permission.camera:
          'The app needs camera permission to take pictures and record video.',
      Permission.microphone:
          'The app needs microphone permission to record audio.',
      Permission.locationWhenInUse: 'The app needs location permission to access your location while using the app.',
      Permission.photos:
          'The app needs photo permission to access photos from your gallery.',
      Permission.storage: 'The app needs storage permission to access files stored on the device.',
      Permission.contacts:
          'The app needs contacts permission to access contacts.',
    };

    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('$name Permission'),
              content: Text(
                descriptions[permission] ??
                    'This permission is required by the app.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _showPermanentlyDeniedDialog(Permission permission) async {
    final name = permissionNames[permission] ?? 'This';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Required'),
          content: Text(
            '$name permission has been permanently denied. '
            'Please open Settings and enable it manually.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> checkAllPermissions() async {
    final Map<Permission, PermissionStatus> result = {};
    for (final permission in permissionNames.keys) {
      result[permission] = await permission.status;
    }

    setState(() {
      statuses = result;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String statusText(Permission permission) {
    final status = statuses[permission];
    if (status == null) {
      return 'Not checked';
    }

    if (status.isGranted) {
      return 'Granted';
    }

    if (status.isDenied) {
      return 'Denied';
    }

    if (status.isPermanentlyDenied) {
      return 'Permanently denied';
    }

    if (status.isRestricted) {
      return 'Restricted';
    }

    if (status.isLimited) {
      return 'Limited';
    }

    return status.toString();
  }

  Color statusColor(Permission permission) {
    final status = statuses[permission];
    if (status?.isGranted == true) {
      return Colors.green;
    }

    if (status?.isPermanentlyDenied == true) {
      return Colors.red;
    }

    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day 11 Permissions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: requestAllPermissions,
                child: const Text('Request All Permissions'),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: checkAllPermissions,
                child: const Text('Check Permission Status'),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: permissionNames.keys.map((permission) {
                  return Card(
                    child: ListTile(
                      title: Text(permissionNames[permission]!),
                      subtitle: Text(
                        statusText(permission),
                        style: TextStyle(
                          color: statusColor(permission),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => requestPermission(permission),
                        child: const Text('Request'),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
