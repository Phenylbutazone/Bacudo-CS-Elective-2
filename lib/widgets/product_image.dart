import 'package:flutter/material.dart';

/// Displays a product image from a local asset or network URL.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  bool get _isAsset => imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isAsset) {
      return Image.asset(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) => _errorPlaceholder(theme),
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, _, _) => _errorPlaceholder(theme),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return ColoredBox(
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _errorPlaceholder(ThemeData theme) {
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: width != null && width! < 64 ? 24 : 48,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
