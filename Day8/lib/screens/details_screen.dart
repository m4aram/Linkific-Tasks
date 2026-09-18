import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String data;

  const DetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Received Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(data, style: const TextStyle(fontSize: 24)),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'Done from Details');
              },
              child: const Text('Return Data'),
            ),
          ],
        ),
      ),
    );
  }
}
