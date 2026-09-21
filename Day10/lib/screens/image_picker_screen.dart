import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isUploading = false;
  bool uploadCompleted = false;

  // Image transformations
  int selectedFilter = 0;
  bool cropMode = false;

  // --------------------------------------------------
  // Pick image from gallery
  // --------------------------------------------------
  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (image == null) return;

      setState(() {
        selectedImage = File(image.path);
        uploadCompleted = false;
        selectedFilter = 0;
        cropMode = false;
      });
    } catch (e) {
      _showMessage('Unable to access gallery.');
    }
  }

  // --------------------------------------------------
  // Take photo with camera
  // --------------------------------------------------
  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (image == null) return;

      setState(() {
        selectedImage = File(image.path);
        uploadCompleted = false;
        selectedFilter = 0;
        cropMode = false;
      });
    } catch (e) {
      _showMessage('Unable to access camera.');
    }
  }

  // --------------------------------------------------
  // Upload image
  // --------------------------------------------------
  Future<void> uploadImage() async {
    if (selectedImage == null) {
      _showMessage('Please select an image first.');
      return;
    }
    setState(() {
      isUploading = true;
      uploadCompleted = false;
    });

    // Simulate upload
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isUploading = false;
      uploadCompleted = true;
    });

    _showMessage('Image upload completed.');
  }

  // --------------------------------------------------
  // Filter
  // --------------------------------------------------
  ColorFilter? get selectedColorFilter {
    switch (selectedFilter) {
      case 1: // Gray
        return const ColorFilter.matrix([
          0.33, 0.33, 0.33, 0, 0, //
          0.33, 0.33, 0.33, 0, 0, //
          0.33, 0.33, 0.33, 0, 0, //
          0, 0, 0, 1, 0,
        ]);
      case 2: // Bright
        return const ColorFilter.matrix([
          1.2, 0, 0, 0, 10, //
          0, 1.2, 0, 0, 10, //
          0, 0, 1.2, 0, 10, //
          0, 0, 0, 1, 0,
        ]);
      case 3: // Negative
        return const ColorFilter.matrix([
          -1, 0, 0, 0, 255, //
          0, -1, 0, 0, 255, //
          0, 0, -1, 0, 255, //
          0, 0, 0, 1, 0,
        ]);
      default:
        return null;
    }
  }

  // --------------------------------------------------
  // Show message
  // --------------------------------------------------
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // --------------------------------------------------
  // Image preview
  // --------------------------------------------------
  Widget _buildImagePreview() {
    if (selectedImage == null) {
      return const SizedBox.shrink();
    }
    Widget image = Image.file(
      selectedImage!,
      width: double.infinity,
      height: 280,
      fit: cropMode ? BoxFit.cover : BoxFit.contain,
    );

    if (selectedColorFilter != null) {
      image = ColorFiltered(colorFilter: selectedColorFilter!, child: image);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        height: 280,
        color: Colors.grey.shade200,
        child: image,
      ),
    );
  }

  // --------------------------------------------------
  // Filter buttons
  // --------------------------------------------------
  Widget _buildFilterButtons() {
    if (selectedImage == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filters',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterButton(title: 'Original', value: 0),
              _filterButton(title: 'Gray', value: 1),
              _filterButton(title: 'Bright', value: 2),
              _filterButton(title: 'Negative', value: 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterButton({required String title, required int value}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            selectedFilter = value;
          });
        },
        child: Text(title),
      ),
    );
  }

  // --------------------------------------------------
  // Build
  // --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery & Camera')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ------------------------------------------
          // Image preview
          // ------------------------------------------
          if (selectedImage != null) ...[
            const Text(
              'Image Preview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildImagePreview(),
            const SizedBox(height: 20),

            // ----------------------------------------
            // Crop mode
            // ----------------------------------------
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Crop Mode'),
              subtitle: const Text('Use BoxFit.cover to crop the image'),
              value: cropMode,
              onChanged: (value) {
                setState(() {
                  cropMode = value;
                });
              },
            ),
            const SizedBox(height: 10),

            // ----------------------------------------
            // Filters
            // ----------------------------------------
            _buildFilterButtons(),
            const SizedBox(height: 25),

            // ----------------------------------------
            // Upload
            // ----------------------------------------
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isUploading ? null : uploadImage,
                icon: const Icon(Icons.cloud_upload),
                label: Text(isUploading ? 'Uploading...' : 'Upload Image'),
              ),
            ),

            if (uploadCompleted)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Upload successful',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 30),
          ],

          // ------------------------------------------
          // Gallery
          // ------------------------------------------
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: pickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick from Gallery'),
            ),
          ),
          const SizedBox(height: 12),

          // ------------------------------------------
          // Camera
          // ------------------------------------------
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
          ),
        ],
      ),
    );
  }
}