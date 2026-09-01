import 'package:cs_elective_2/models/product.dart';
import 'package:cs_elective_2/state/cart_notifier.dart';
import 'package:cs_elective_2/widgets/product_image.dart';
import 'package:cs_elective_2/widgets/quantity_control.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Cart screen — quantities and totals change with user input.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WiredScaffold(
      appBar: WiredAppBar(
        title: 'Your Cart',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListenableBuilder(
        listenable: cartNotifier,
        builder: (context, _) {
          if (cartNotifier.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your cart is empty.',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The wired waits for no one.',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const WiredDivider(),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.go('/'),
                      child: const Text('[Browse catalog]'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartNotifier.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = cartNotifier.items[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              _CartSummary(
                grandTotal: cartNotifier.grandTotal,
                onCheckout: () => context.go('/checkout'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  static final _currency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WiredPanel(
      child: Row(
        children: [
          ProductImage(
            imageUrl: item.product.imageUrl,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            dithered: true,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_currency.format(item.product.price)} each',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'subtotal: ${_currency.format(item.subtotal)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          QuantityControl(
            quantity: item.quantity,
            onIncrement: () => cartNotifier.increment(item.product),
            onDecrement: () => cartNotifier.decrement(item.product),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.grandTotal,
    required this.onCheckout,
  });

  final double grandTotal;
  final VoidCallback onCheckout;

  static final _currency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grand Total', style: theme.textTheme.titleLarge),
              Text(
                _currency.format(grandTotal),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onCheckout,
            child: const Text('[Proceed to checkout]'),
          ),
        ],
      ),
    );
  }
}
