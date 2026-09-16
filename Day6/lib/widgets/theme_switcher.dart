import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final VoidCallback onToggle;

  const ThemeSwitcher({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Toggle theme',
          onPressed: onToggle,
          icon: Icon(
            themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            color: colorScheme.primary,
          ),
        ),

        PopupMenuButton<ThemeMode>(
          tooltip: 'Choose theme mode',
          initialValue: themeMode,
          onSelected: onThemeChanged,
          icon: Icon(Icons.palette_outlined, color: colorScheme.primary),
          itemBuilder: (context) => const [
            PopupMenuItem(value: ThemeMode.system, child: Text('System')),
            PopupMenuItem(value: ThemeMode.light, child: Text('Light')),
            PopupMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          ],
        ),
      ],
    );
  }
}
