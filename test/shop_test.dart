import 'dart:async';

import 'package:cs_elective_2/data/product_repository.dart';
import 'package:cs_elective_2/data/products.dart';
import 'package:cs_elective_2/models/product.dart';
import 'package:cs_elective_2/pages/keyboard_list_page.dart';
import 'package:cs_elective_2/state/shop_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory stand-in for Supabase that mirrors the real query:
/// `gte/lte` on price, `order(price, id)`, inclusive `range(from, to)`.
class FakeProductRepository implements ProductRepository {
  FakeProductRepository(this.catalogue);

  final List<Product> catalogue;
  final calls = <({int page, double? min, double? max})>[];
  Object? failWith;

  /// When set, `fetchPage` waits on this before answering.
  Completer<void>? gate;

  @override
  Future<ProductPage> fetchPage({
    required int page,
    required int pageSize,
    double? minPrice,
    double? maxPrice,
  }) async {
    calls.add((page: page, min: minPrice, max: maxPrice));
    final g = gate;
    if (g != null) await g.future;
    if (failWith != null) throw failWith!;
    final matches =
        catalogue
            .where((p) => minPrice == null || p.price >= minPrice)
            .where((p) => maxPrice == null || p.price <= maxPrice)
            .toList()
          ..sort((a, b) {
            final byPrice = a.price.compareTo(b.price);
            return byPrice != 0 ? byPrice : a.id.compareTo(b.id);
          });
    final from = page * pageSize;
    final items = matches.skip(from).take(pageSize).toList();
    return ProductPage(items: items, totalCount: matches.length);
  }

  @override
  Future<PriceBounds?> fetchPriceBounds() async {
    if (failWith != null) throw failWith!;
    if (catalogue.isEmpty) return null;
    final prices = catalogue.map((p) => p.price);
    return PriceBounds(
      min: prices.reduce((a, b) => a < b ? a : b),
      max: prices.reduce((a, b) => a > b ? a : b),
    );
  }
}

Product _product(String id, double price) => Product(
  id: id,
  name: 'Keyboard $id',
  price: price,
  imageUrl: '',
  description: '',
  category: 'Test',
);

/// 14 products priced 10, 20, ... 140.
final _catalogue = [for (var i = 1; i <= 14; i++) _product('k$i', i * 10.0)];

void main() {
  group('ShopNotifier', () {
    test('loads price bounds and the first page of 6', () async {
      final repo = FakeProductRepository(_catalogue);
      final shop = ShopNotifier(repo);
      await shop.load();

      expect(shop.priceBounds, const RangeValues(10, 140));
      expect(shop.priceRange, shop.priceBounds);
      expect(shop.items, hasLength(6));
      expect(shop.items.first.price, 10);
      expect(shop.totalCount, 14);
      expect(shop.totalPages, 3);
      expect(shop.hasPreviousPage, isFalse);
      expect(shop.hasNextPage, isTrue);
      expect(shop.isLoading, isFalse);
    });

    test('pages forward and back with server-side ranges', () async {
      final repo = FakeProductRepository(_catalogue);
      final shop = ShopNotifier(repo);
      await shop.load();

      await shop.nextPage();
      expect(shop.page, 1);
      expect(shop.items.map((p) => p.price), [70, 80, 90, 100, 110, 120]);

      await shop.nextPage();
      expect(shop.page, 2);
      expect(shop.items.map((p) => p.price), [130, 140]);
      expect(shop.hasNextPage, isFalse);

      await shop.nextPage(); // no-op past the end
      expect(shop.page, 2);

      await shop.previousPage();
      expect(shop.page, 1);
      expect(repo.calls.map((c) => c.page), [0, 1, 2, 1]);
    });

    test('applying a price range filters and resets to page 1', () async {
      final repo = FakeProductRepository(_catalogue);
      final shop = ShopNotifier(repo);
      await shop.load();
      await shop.nextPage();
      expect(shop.page, 1);

      await shop.applyPriceRange(const RangeValues(30, 90));
      expect(shop.page, 0);
      expect(repo.calls.last, (page: 0, min: 30.0, max: 90.0));
      expect(shop.items.map((p) => p.price), [30, 40, 50, 60, 70, 80]);
      expect(shop.totalCount, 7);
      expect(shop.isFiltered, isTrue);

      await shop.nextPage();
      expect(shop.items.map((p) => p.price), [90]);

      await shop.resetPriceRange();
      expect(shop.page, 0);
      expect(shop.totalCount, 14);
      expect(shop.isFiltered, isFalse);
    });

    test('a range with no matches yields an empty result', () async {
      final shop = ShopNotifier(FakeProductRepository(_catalogue));
      await shop.load();
      await shop.applyPriceRange(const RangeValues(11, 19));
      expect(shop.items, isEmpty);
      expect(shop.totalPages, 0);
      expect(shop.hasNextPage, isFalse);
    });

    test('ignores stale responses from superseded requests', () async {
      final repo = FakeProductRepository(_catalogue);
      final shop = ShopNotifier(repo);
      await shop.load();

      final gate = repo.gate = Completer<void>();
      final slow = shop.applyPriceRange(const RangeValues(10, 50));
      repo.gate = null;
      await shop.applyPriceRange(const RangeValues(100, 140));
      expect(shop.items.map((p) => p.price), [100, 110, 120, 130, 140]);

      // The earlier (slower) request finishes last but must not win.
      gate.complete();
      await slow;
      expect(shop.items.map((p) => p.price), [100, 110, 120, 130, 140]);
      expect(shop.priceRange, const RangeValues(100, 140));
      expect(shop.isLoading, isFalse);
    });

    test('surfaces errors and retries the page that failed', () async {
      final repo = FakeProductRepository(_catalogue);
      final shop = ShopNotifier(repo);
      await shop.load();

      repo.failWith = Exception('offline');
      await shop.nextPage();
      expect(shop.error, isNotNull);
      expect(shop.isLoading, isFalse);
      expect(shop.page, 0); // still showing the last good page

      repo.failWith = null;
      await shop.retry();
      expect(shop.error, isNull);
      expect(shop.page, 1);
    });

    test('empty catalogue has no bounds and no items', () async {
      final shop = ShopNotifier(FakeProductRepository(const []));
      await shop.load();
      expect(shop.priceBounds, isNull);
      expect(shop.items, isEmpty);
      expect(shop.isLoading, isFalse);
    });
  });

  group('KeyboardListPage', () {
    Future<FakeProductRepository> pumpPage(WidgetTester tester) async {
      final repo = FakeProductRepository(_catalogue);
      await tester.pumpWidget(
        MaterialApp(home: KeyboardListPage(repository: repo)),
      );
      expect(find.text('Loading keyboards...'), findsOneWidget);
      await tester.pumpAndSettle();
      return repo;
    }

    testWidgets('shows 6 products per page and pages with Next/Previous', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.text('Page 1 of 3'), findsOneWidget);
      expect(find.text('Showing 1–6 of 14'), findsOneWidget);
      expect(find.text('Keyboard k1'), findsOneWidget);
      expect(find.text('Keyboard k7'), findsNothing);

      await tester.tap(find.byKey(const Key('next-page')));
      await tester.pumpAndSettle();
      expect(find.text('Page 2 of 3'), findsOneWidget);
      expect(find.text('Keyboard k7'), findsOneWidget);
      expect(find.text('Keyboard k1'), findsNothing);

      await tester.tap(find.byKey(const Key('prev-page')));
      await tester.pumpAndSettle();
      expect(find.text('Page 1 of 3'), findsOneWidget);
    });

    testWidgets('dragging the price slider filters and resets to page 1', (
      tester,
    ) async {
      final repo = await pumpPage(tester);
      await tester.tap(find.byKey(const Key('next-page')));
      await tester.pumpAndSettle();
      expect(find.text('Page 2 of 3'), findsOneWidget);

      // Drag the upper thumb from the right edge to roughly the middle.
      final slider = find.byKey(const Key('price-range-slider'));
      final rect = tester.getRect(slider);
      await tester.dragFrom(
        Offset(rect.right - 24, rect.center.dy),
        Offset(-rect.width / 2, 0),
      );
      await tester.pumpAndSettle();

      final last = repo.calls.last;
      expect(last.page, 0);
      expect(last.max, lessThan(140));
      expect(find.text('Page 1 of 2'), findsOneWidget);
    });
  });

  test('productById prefers products fetched from Supabase', () {
    productCache['remote-only'] = _product('remote-only', 1);
    addTearDown(() => productCache.remove('remote-only'));
    expect(productById('remote-only')?.price, 1);
    expect(productById('wooting-60he'), isNotNull);
  });
}
