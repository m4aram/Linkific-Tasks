import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(Icons.person, size: 45),
          ),
          const SizedBox(height: 16),
          const Text(
            'Flutter Developer',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text('Dart • Flutter • Firebase'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.code),
              const SizedBox(width: 8),
              const Text('Mobile App Development'),
            ],
          ),
        ],
      ),
    );
  }
}