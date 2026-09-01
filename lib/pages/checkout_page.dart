import 'package:cs_elective_2/state/cart_notifier.dart';
import 'package:cs_elective_2/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Checkout confirmation — read-only summary after placing an order.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  static final _currency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = List.of(cartNotifier.items);
    final total = cartNotifier.grandTotal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Thank you for your order!',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Your order is on its way.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            Text('Order Summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: ProductImage(
                      imageUrl: item.product.imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(item.product.name),
                  subtitle: Text(
                    '${item.quantity} × ${_currency.format(item.product.price)}',
                  ),
                  trailing: Text(
                    _currency.format(item.subtotal),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grand Total',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      _currency.format(total),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                cartNotifier.clear();
                context.go('/');
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
