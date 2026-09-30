import 'package:flutter/material.dart';

/// Shows a flag image from the network. If it fails to load, falls back to the flag emoji.
class FlagImage extends StatelessWidget {
  final String url;
  final String emoji;
  final double? width;
  final double height;
  final BoxFit fit;

  const FlagImage({
    super.key,
    required this.url,
    required this.emoji,
    required this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            emoji.isEmpty ? '🏳' : emoji,
            style: TextStyle(fontSize: height * 0.7),
          ),
        ),
      ),
    );
  }
}
