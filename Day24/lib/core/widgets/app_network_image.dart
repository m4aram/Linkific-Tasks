import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoplite/core/utils/validators.dart';

/// Network image with caching.
///
/// * Disk cache: an image is downloaded once and reused across launches.
/// * Memory cache: the image is decoded at the size it is shown at
///   (`memCacheWidth`) instead of full resolution, which keeps scrolling
///   smooth and memory low.
/// * Only `https://` URLs are loaded.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.semanticLabel,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  /// Describe the picture for screen readers. Leave null when the image is
  /// decorative (the surrounding widget already describes it).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final semanticLabel = this.semanticLabel;

    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: SizedBox(width: width, height: height),
    );
    final fallback = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );

    Widget image;
    if (Validators.isHttpsUrl(url)) {
      final logicalWidth = width ?? MediaQuery.sizeOf(context).width;
      final pixelRatio = MediaQuery.devicePixelRatioOf(context);
      image = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: (logicalWidth * pixelRatio).round(),
        fadeInDuration: const Duration(milliseconds: 150),
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => fallback,
      );
    } else {
      image = fallback;
    }

    image = ClipRRect(borderRadius: borderRadius, child: image);

    if (semanticLabel == null) {
      return ExcludeSemantics(child: image);
    }
    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: image,
    );
  }
}
