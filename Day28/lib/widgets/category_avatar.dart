import 'package:flutter/material.dart';

import '../utils/category_style.dart';

/// Round category icon. When [heroTag] is set it flies between the list
/// and the details screen.
class CategoryAvatar extends StatelessWidget {
  final String category;
  final double size;
  final Object? heroTag;

  const CategoryAvatar({
    super.key,
    required this.category,
    this.size = 44,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyle.of(category);
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Icon(
        style.icon,
        color: style.color,
        size: size * 0.5,
        semanticLabel: category,
      ),
    );

    return heroTag == null ? avatar : Hero(tag: heroTag!, child: avatar);
  }
}
