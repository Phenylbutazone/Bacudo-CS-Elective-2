import 'package:cs_elective_2/data/products.dart';
import 'package:cs_elective_2/state/cart_notifier.dart';
import 'package:cs_elective_2/state/theme_notifier.dart';
import 'package:cs_elective_2/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home screen — responsive product grid with theme toggle.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  int _columnCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fresh Fruit Market'),
        actions: [
          // Navigation 1.0 — imperative push for the About screen.
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const _AboutPage(),
                ),
              );
            },
          ),
          ListenableBuilder(
            listenable: themeNotifier,
            builder: (context, _) {
              return IconButton(
                icon: Icon(
                  themeNotifier.isDark ? Icons.light_mode : Icons.dark_mode,
                ),
                tooltip: 'Toggle theme',
                onPressed: themeNotifier.toggle,
              );
            },
          ),
          ListenableBuilder(
            listenable: cartNotifier,
            builder: (context, _) {
              return IconButton(
                icon: Badge(
                  isLabelVisible: cartNotifier.totalItemCount > 0,
                  label: Text('${cartNotifier.totalItemCount}'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                tooltip: 'Cart',
                onPressed: () => context.go('/cart'),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _columnCount(constraints.maxWidth);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => context.go('/product/${product.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

/// About screen reached via Navigation 1.0 (Navigator.push).
class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fresh Fruit Market',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Your daily source for farm-fresh produce. Browse our '
              'selection, add items to your cart, and checkout in seconds.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Icon(Icons.eco, color: theme.colorScheme.primary),
                title: const Text('100% Fresh Guarantee'),
                subtitle: const Text(
                  'Every item is hand-picked and delivered at peak freshness.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
