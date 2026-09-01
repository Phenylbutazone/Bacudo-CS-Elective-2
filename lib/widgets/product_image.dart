import 'package:flutter/material.dart';

/// Displays a product image from a local asset or network URL.
/// Optional dithered treatment inspired by fauux.neocities.org compression.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.dithered = false,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool dithered;

  bool get _isAsset => imageUrl.startsWith('assets/');

  static const _ditherMatrix = ColorFilter.matrix(<double>[
    1.15, -0.05, -0.05, 0, -12,
    -0.05, 1.1, -0.05, 0, -12,
    -0.05, -0.05, 1.05, 0, -12,
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = _isAsset
        ? Image.asset(
            imageUrl,
            fit: fit,
            width: width,
            height: height,
            filterQuality: dithered ? FilterQuality.none : FilterQuality.medium,
            errorBuilder: (_, _, _) => _errorPlaceholder(theme),
          )
        : Image.network(
            imageUrl,
            fit: fit,
            width: width,
            height: height,
            filterQuality: dithered ? FilterQuality.none : FilterQuality.medium,
            errorBuilder: (_, _, _) => _errorPlaceholder(theme),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return ColoredBox(
                color: theme.scaffoldBackgroundColor,
                child: Center(
                  child: Text(
                    'Loading...',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              );
            },
          );

    if (!dithered) return image;

    return ColorFiltered(
      colorFilter: _ditherMatrix,
      child: image,
    );
  }

  Widget _errorPlaceholder(ThemeData theme) {
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: Center(
          child: Text(
            '[no signal]',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
