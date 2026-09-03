import 'package:cs_elective_2/data/products.dart';
import 'package:cs_elective_2/state/cart_notifier.dart';
import 'package:cs_elective_2/state/theme_notifier.dart';
import 'package:cs_elective_2/widgets/product_card.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home screen — responsive product grid with wired neocities styling.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  int _columnCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return WiredScaffold(
          appBar: WiredAppBar(
            title: 'Keyboard Store',
            actions: [
              IconButton(
                icon: const Icon(Icons.view_list_outlined),
                tooltip: 'Keyboard list',
                onPressed: () => context.go('/keyboards'),
              ),
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
              IconButton(
                icon: Icon(
                  themeNotifier.isVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                tooltip: themeNotifier.isVisible
                    ? 'Go invisible'
                    : 'Go visible',
                onPressed: themeNotifier.toggle,
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

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: WiredHeroHeader(
                      isVisible: themeNotifier.isVisible,
                      onToggleVisibility: themeNotifier.toggle,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () =>
                                context.go('/product/${product.id}'),
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

/// About screen reached via Navigation 1.0 (Navigator.push).
class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WiredScaffold(
      appBar: WiredAppBar(
        title: 'About',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('⌈', style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              'Keyboard Store',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const WiredDivider(),
            const SizedBox(height: 12),
            Text(
              'Your go-to shop for mechanical and gaming keyboards on the '
              'wired. Browse our selection, add items to your cart, and '
              'checkout in seconds.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'このサイトはウェブ文化、マニアックな音楽、日本、'
              'ポスト/トランスヒューマニズムに捧げられています。',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            WiredPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Gear Guarantee',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Every keyboard is quality-checked before it ships.',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const WiredDivider(),
            Text(
              'fauux © 2013-2025 · inspired layout',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
