import 'package:cs_elective_2/data/products.dart';
import 'package:cs_elective_2/widgets/product_image.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class KeyboardDetailPage extends StatelessWidget {
  const KeyboardDetailPage({super.key, required this.id});

  final String id;

  static final _currency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final product = productById(id);
    final theme = Theme.of(context);

    if (product == null) {
      return WiredScaffold(
        appBar: WiredAppBar(
          title: 'Not found',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/keyboards'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No keyboard matched that name.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/keyboards'),
                child: const Text('[Back to list]'),
              ),
            ],
          ),
        ),
      );
    }

    return WiredScaffold(
      appBar: WiredAppBar(
        title: product.name,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/keyboards'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProductImage(
                imageUrl: product.imageUrl,
                width: 220,
                height: 220,
                fit: BoxFit.cover,
                dithered: true,
              ),
              const SizedBox(height: 32),
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _currency.format(product.price),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/keyboards'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('[Back to keyboards]'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
