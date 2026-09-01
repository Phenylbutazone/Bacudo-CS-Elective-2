import 'package:cs_elective_2/state/cart_notifier.dart';
import 'package:cs_elective_2/widgets/product_image.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
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

    return WiredScaffold(
      appBar: const WiredAppBar(title: 'Order Confirmed'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Connection established.',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const WiredDivider(),
            const SizedBox(height: 12),
            Text(
              'Thank you for your order.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Your signal is on its way through the wired.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 32),
            Text('# Order Summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: WiredPanel(
                  child: Row(
                    children: [
                      ProductImage(
                        imageUrl: item.product.imageUrl,
                        width: 48,
                        height: 48,
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
                              '${item.quantity} × '
                              '${_currency.format(item.product.price)}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _currency.format(item.subtotal),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            WiredPanel(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Grand Total', style: theme.textTheme.titleLarge),
                  Text(
                    _currency.format(total),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const WiredDivider(label: 'Let\'s all love keyboards.'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                cartNotifier.clear();
                context.go('/');
              },
              child: const Text('[Continue shopping]'),
            ),
          ],
        ),
      ),
    );
  }
}
