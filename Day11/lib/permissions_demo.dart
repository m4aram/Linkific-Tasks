import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const PermissionsDemo());
}

class PermissionsDemo extends StatelessWidget {
  const PermissionsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Day 11 Permissions',
      home: const PermissionsPage(),
    );
  }
}

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  final Map<String, Permission> permissions = {
    'Camera': Permission.camera,
    'Microphone': Permission.microphone,
    'Location': Permission.locationWhenInUse,
    'Gallery / Photos': Permission.photos,
    'Storage': Permission.storage,
    'Contacts': Permission.contacts,
  };

  Map<String, PermissionStatus> statuses = {};

  @override
  void initState() {
    super.initState();
    checkAllPermissions();
  }

  // Check all permissions
  Future<void> checkAllPermissions() async {
    final Map<String, PermissionStatus> result = {};

    for (final entry in permissions.entries) {
      result[entry.key] = await entry.value.status;
    }

    if (!mounted) return;

    setState(() {
      statuses = result;
    });
  }

  // Request all permissions
  Future<void> requestAllPermissions() async {
    for (final entry in permissions.entries) {
      await requestSinglePermission(
        entry.value,
        entry.key,
      );
    }

    await checkAllPermissions();
  }

  // Request one permission
  Future<void> requestSinglePermission(
      Permission permission,
      String name,
      ) async {
    PermissionStatus status = await permission.status;

    // Already granted
    if (status.isGranted) {
      showMessage('$name permission is already granted.');
      return;
    }

    // Permanently denied
    if (status.isPermanentlyDenied) {
      await showPermanentDeniedDialog(name);
      return;
    }

    // Request permission
    status = await permission.request();

    if (!mounted) return;

    if (status.isGranted) {
      showMessage('$name permission granted.');
    } else if (status.isDenied) {
      showMessage('$name permission denied.');
    } else if (status.isPermanentlyDenied) {
      await showPermanentDeniedDialog(name);
    }

    await checkAllPermissions();
  }

  // Permanently denied dialog
  Future<void> showPermanentDeniedDialog(String name) async {
    if (!mounted) return;

    final bool? openSettings = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$name Permission'),
          content: Text(
            '$name permission was permanently denied.\n\n'
                'Please enable it from the app settings.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );

    if (openSettings == true) {
      await openAppSettings();
    }
  }

  // Show message
  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Get status text
  String statusText(PermissionStatus? status) {
    if (status == null) {
      return 'Unknown';
    }

    if (status.isGranted) {
      return 'Granted';
    }

    if (status.isPermanentlyDenied) {
      return 'Permanently Denied';
    }

    if (status.isDenied) {
      return 'Denied';
    }

    if (status.isRestricted) {
      return 'Restricted';
    }

    if (status.isLimited) {
      return 'Limited';
    }

    return status.toString();
  }

  // Get status color
  Color statusColor(PermissionStatus? status) {
    if (status?.isGranted == true) {
      return Colors.green;
    }

    if (status?.isPermanentlyDenied == true) {
      return Colors.red;
    }

    if (status?.isDenied == true) {
      return Colors.orange;
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day 11 Permissions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Request all permissions
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: requestAllPermissions,
              child: const Text('Request All Permissions'),
            ),
          ),

          const SizedBox(height: 12),

          // Check permission status
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: checkAllPermissions,
              child: const Text('Check Permission Status'),
            ),
          ),

          const SizedBox(height: 20),

          // Permissions
          ...permissions.entries.map(
                (entry) {
              final String name = entry.key;
              final Permission permission = entry.value;
              final PermissionStatus? status = statuses[name];

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              statusText(status),
                              style: TextStyle(
                                color: statusColor(status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          requestSinglePermission(
                            permission,
                            name,
                          );
                        },
                        child: const Text('Request'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}