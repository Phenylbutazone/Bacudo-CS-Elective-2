import 'package:cs_elective_2/data/products.dart';
import 'package:cs_elective_2/widgets/product_image.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class KeyboardListPage extends StatelessWidget {
  const KeyboardListPage({super.key});

  static final _currency = NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WiredScaffold(
      appBar: const WiredAppBar(title: 'Keyboards'),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: products.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          color: theme.dividerColor,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: ProductImage(
              imageUrl: product.imageUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              dithered: true,
            ),
            title: Text(product.name),
            subtitle: Text(
              '${_currency.format(product.price)} · ${product.category}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(
              '/keyboard/${Uri.encodeComponent(product.id)}',
            ),
          );
        },
      ),
    );
  }
}
