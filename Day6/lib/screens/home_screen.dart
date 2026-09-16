import 'package:flutter/material.dart';


import '../ theme/app_theme.dart';
import '../main.dart';
import '../widgets/theme_switcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final provider = ThemeProviderScope.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Showcase'),
        actions: [
          ThemeSwitcher(
            themeMode: provider.themeMode,
            onThemeChanged: provider.setThemeMode,
            onToggle: provider.toggleTheme,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Flutter Theming', style: text.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Material 3 themed application with light and dark modes.',
            style: text.bodyLarge,
          ),
          const SizedBox(height: 24),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.palette, size: 42, color: colors.primary),
                  const SizedBox(height: 12),
                  Text('Custom Theme', style: text.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'This card uses colors and styling from ThemeData.',
                    style: text.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Semantic Colors', style: text.titleLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Success'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('Warning'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Error',
                            style: TextStyle(
                              color: colors.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            decoration: const InputDecoration(
              labelText: 'Themed Text Field',
              hintText: 'Enter something...',
              prefixIcon: Icon(Icons.edit),
            ),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme button pressed')),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Primary Button'),
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            label: const Text('Outlined Button'),
          ),

          const SizedBox(height: 10),

          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.palette),
            label: const Text('Filled Button'),
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Notifications'),
            subtitle: const Text('This component follows the application theme.'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() => notificationsEnabled = value);
            },
          ),

          const Divider(),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: colors.primaryContainer,
              child: Icon(
                Icons.brightness_6,
                color: colors.onPrimaryContainer,
              ),
            ),
            title: const Text('Current Theme Mode'),
            subtitle: Text(provider.themeMode.name.toUpperCase()),
          ),

          const SizedBox(height: 20),

          Text('Theme.of(context)', style: text.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Colors and text styles are accessed from the current theme to keep the UI consistent.',
            style: text.bodyMedium,
          ),
        ],
      ),
    );
  }
}
