import 'package:cs_elective_2/data/product_repository.dart';
import 'package:cs_elective_2/models/product.dart';
import 'package:cs_elective_2/state/shop_notifier.dart';
import 'package:cs_elective_2/widgets/product_image.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Keyboard shop listing backed by Supabase, with a price range filter and
/// server-side pagination ([ShopNotifier.pageSize] products per page).
class KeyboardListPage extends StatefulWidget {
  const KeyboardListPage({super.key, this.repository, this.pageSize});

  /// Defaults to [SupabaseProductRepository]. Injected in tests.
  final ProductRepository? repository;
  final int? pageSize;

  @override
  State<KeyboardListPage> createState() => _KeyboardListPageState();
}

class _KeyboardListPageState extends State<KeyboardListPage> {
  static final _currency = NumberFormat.simpleCurrency();

  late final ShopNotifier _shop;

  /// Slider position while dragging. The query only runs on release, so
  /// this can differ from [ShopNotifier.priceRange].
  RangeValues? _draftRange;

  @override
  void initState() {
    super.initState();
    _shop = ShopNotifier(
      widget.repository ?? SupabaseProductRepository(),
      pageSize: widget.pageSize ?? ShopNotifier.defaultPageSize,
    );
    _shop.load();
  }

  @override
  void dispose() {
    _shop.dispose();
    super.dispose();
  }

  void _applyRange(RangeValues range) {
    setState(() => _draftRange = null);
    _shop.applyPriceRange(range);
  }

  void _resetRange() {
    setState(() => _draftRange = null);
    _shop.resetPriceRange();
  }

  @override
  Widget build(BuildContext context) {
    return WiredScaffold(
      appBar: WiredAppBar(
        title: 'Keyboards',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Home',
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListenableBuilder(
        listenable: _shop,
        builder: (context, _) {
          // First load (or failed first load): nothing to filter yet.
          if (_shop.priceBounds == null) {
            if (_shop.isLoading) return const _LoadingView();
            if (_shop.error != null) {
              return _ErrorView(error: _shop.error!, onRetry: _shop.retry);
            }
            return const _MessageView(
              icon: Icons.inventory_2_outlined,
              message: 'No keyboards in the catalogue yet.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PriceFilter(
                bounds: _shop.priceBounds!,
                value: _draftRange ?? _shop.priceRange!,
                isFiltered: _shop.isFiltered,
                currency: _currency,
                onChanged: (range) => setState(() => _draftRange = range),
                onChangeEnd: _applyRange,
                onReset: _resetRange,
              ),
              // Keep the old page visible while the next one loads.
              SizedBox(
                height: 2,
                child: _shop.isLoading
                    ? const LinearProgressIndicator()
                    : const SizedBox.shrink(),
              ),
              Expanded(child: _buildResults(context)),
              _PaginationBar(shop: _shop),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (_shop.error != null) {
      return _ErrorView(error: _shop.error!, onRetry: _shop.retry);
    }
    if (_shop.items.isEmpty) {
      if (_shop.isLoading) return const _LoadingView();
      return _MessageView(
        icon: Icons.filter_alt_off_outlined,
        message: 'No keyboards in this price range.',
        action: OutlinedButton(
          onPressed: _resetRange,
          child: const Text('[Reset filter]'),
        ),
      );
    }

    final theme = Theme.of(context);
    return ListView.separated(
      key: ValueKey('page-${_shop.page}'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _shop.items.length,
      separatorBuilder: (_, _) => Divider(height: 1, color: theme.dividerColor),
      itemBuilder: (context, index) =>
          _ProductTile(product: _shop.items[index], currency: _currency),
    );
  }
}

class _PriceFilter extends StatelessWidget {
  const _PriceFilter({
    required this.bounds,
    required this.value,
    required this.isFiltered,
    required this.currency,
    required this.onChanged,
    required this.onChangeEnd,
    required this.onReset,
  });

  final RangeValues bounds;
  final RangeValues value;
  final bool isFiltered;
  final NumberFormat currency;
  final ValueChanged<RangeValues> onChanged;
  final ValueChanged<RangeValues> onChangeEnd;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final divisions = (bounds.end - bounds.start).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Price', style: theme.textTheme.titleSmall),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${currency.format(value.start)} – '
                  '${currency.format(value.end)}',
                  key: const Key('price-range-label'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: isFiltered ? onReset : null,
                child: const Text('[Reset]'),
              ),
            ],
          ),
          RangeSlider(
            key: const Key('price-range-slider'),
            min: bounds.start,
            max: bounds.end,
            divisions: divisions > 0 ? divisions : null,
            values: value,
            labels: RangeLabels(
              currency.format(value.start),
              currency.format(value.end),
            ),
            onChanged: onChanged,
            onChangeEnd: onChangeEnd,
          ),
        ],
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({required this.shop});

  final ShopNotifier shop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = shop.isLoading;
    final total = shop.totalCount;
    final first = total == 0 ? 0 : shop.page * shop.pageSize + 1;
    final last = first == 0 ? 0 : first + shop.items.length - 1;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              IconButton(
                key: const Key('prev-page'),
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Previous page',
                onPressed: !busy && shop.hasPreviousPage
                    ? shop.previousPage
                    : null,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shop.totalPages == 0
                          ? 'Page 0 of 0'
                          : 'Page ${shop.page + 1} of ${shop.totalPages}',
                      key: const Key('page-indicator'),
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      'Showing $first–$last of $total',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('next-page'),
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Next page',
                onPressed: !busy && shop.hasNextPage ? shop.nextPage : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.currency});

  final Product product;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
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
        '${currency.format(product.price)} · ${product.category}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go('/keyboard/${Uri.encodeComponent(product.id)}'),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading keyboards...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      icon: Icons.cloud_off_outlined,
      message: 'Could not load keyboards.',
      detail: '$error',
      action: OutlinedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({
    required this.icon,
    required this.message,
    this.detail,
    this.action,
  });

  final IconData icon;
  final String message;
  final String? detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(
                detail!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}
