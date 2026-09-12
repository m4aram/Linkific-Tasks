import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget
{ const SettingsScreen({super.key});

@override
State<SettingsScreen> createState() => _SettingsScreenState(); }

class _SettingsScreenState extends State<SettingsScreen>
{ bool notifications = true; bool darkMode = false;

final List<String> settings =
[ 'Account', 'Privacy', 'Security', 'Language', 'Help & Support', ];
@override Widget build(BuildContext context) {

  return Scaffold(
    appBar: AppBar( title: const Text('Settings'), ),
    body: ListView.separated( itemCount: settings.length + 3,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) { if (index < settings.length)
      { return ListTile( leading: const Icon(Icons.settings), title: Text(settings[index]),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () {}, ); }
if (index == settings.length) {
  return SwitchListTile(
    title: const Text('Notifications'),
    subtitle: const Text('Receive notifications'),
    secondary: const Icon(Icons.notifications),
    value: notifications,
    onChanged: (value) {
      setState(() {
        notifications = value;
      });
    },
  );
}

if (index == settings.length + 1) {
  return SwitchListTile(
    title: const Text('Dark Mode'),
    subtitle: const Text('Change application appearance'),
    secondary: const Icon(Icons.dark_mode),
    value: darkMode,
    onChanged: (value) {
      setState(() {
        darkMode = value;
      });
    },
  );
}

return const ListTile(
  leading: Icon(Icons.info),
  title: Text('About'),
  trailing: Icon(Icons.arrow_forward_ios, size: 16),
);
},
),
);
} }