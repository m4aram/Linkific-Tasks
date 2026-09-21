import 'package:flutter/material.dart';

import 'asset_images_screen.dart';
import 'network_images_screen.dart';
import 'image_picker_screen.dart';
import 'gallery_screen.dart';
import 'image_viewer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Image Handling')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildButton(
            context,
            title: 'Asset Images',
            screen: const AssetImagesScreen(),
          ),
          _buildButton(
            context,
            title: 'Network Images',
            screen: const NetworkImagesScreen(),
          ),

          _buildButton(
            context,
            title: 'Image Picker',
            screen: const ImagePickerScreen(),
          ),

          _buildButton(
            context,
            title: 'Gallery',
            screen: const GalleryScreen(),
          ),

          _buildButton(
            context,
            title: 'Image Viewer',
            screen: const ImageViewerScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required Widget screen,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Text(title),
        ),
      ),
    );
  }
}
