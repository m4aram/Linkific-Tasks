import 'package:flutter/material.dart';

class AssetImagesScreen extends StatelessWidget {
  const AssetImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asset Images')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Local Asset Image',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: Image.asset('assets/images/sample1.jpg', fit: BoxFit.cover),
          ),

          const SizedBox(height: 24),

          const Text(
            'Contain Example',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            child: Image.asset(
              'assets/images/sample2.jpg',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
