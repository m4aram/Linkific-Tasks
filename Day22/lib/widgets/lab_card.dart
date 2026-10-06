import 'package:flutter/material.dart';

class LabCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const LabCard({super.key, required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle!, style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// The switch that turns a lab from "buggy" to "fixed".
class FixSwitch extends StatelessWidget {
  final bool fixed;
  final ValueChanged<bool> onChanged;

  const FixSwitch({super.key, required this.fixed, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(fixed ? 'FIXED version' : 'BUGGY version'),
      subtitle: const Text('Switch to compare'),
      value: fixed,
      onChanged: onChanged,
    );
  }
}
