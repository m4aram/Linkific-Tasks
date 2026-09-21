import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImagesScreen extends StatelessWidget {
  const NetworkImagesScreen({super.key});

  static const String imageUrl =
      'https://images.unsplash.com/photo-1516321318423-f06f85e504b3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network Images')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Image.network',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Failed to load image'));
              },
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'CachedNetworkImage',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return const Center(child: CircularProgressIndicator());
              },
              errorWidget: (context, url, error) {
                return const Center(child: Icon(Icons.error, size: 50));
              },
              fadeInDuration: const Duration(milliseconds: 500),
            ),
          ),
        ],
      ),
    );
  }
}
