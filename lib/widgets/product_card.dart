import 'package:cs_elective_2/models/product.dart';
import 'package:cs_elective_2/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Static product card — display-only, so a [StatelessWidget].
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  static final _currency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.dividerColor;

    return Material(
      color: theme.cardTheme.color,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ProductImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  dithered: true,
                ),
              ),
              Container(
                height: 1,
                color: border,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _currency.format(product.price),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
