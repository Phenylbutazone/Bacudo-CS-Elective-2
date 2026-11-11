import 'package:cs_elective_2/models/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// One page of products plus the total number of rows matching the filter.
class ProductPage {
  const ProductPage({required this.items, required this.totalCount});

  final List<Product> items;
  final int totalCount;
}

/// Cheapest and most expensive price in the catalogue. Used as the
/// outer limits of the price filter slider.
class PriceBounds {
  const PriceBounds({required this.min, required this.max});

  final double min;
  final double max;
}

/// Read access to the product catalogue. Abstract so tests can swap in an
/// in-memory fake instead of hitting Supabase.
abstract class ProductRepository {
  /// Fetches page [page] (0-based) of at most [pageSize] products whose price
  /// is within [minPrice]..[maxPrice] (inclusive), ordered by price.
  Future<ProductPage> fetchPage({
    required int page,
    required int pageSize,
    double? minPrice,
    double? maxPrice,
  });

  /// Returns the lowest and highest product price, or `null` if the
  /// catalogue is empty.
  Future<PriceBounds?> fetchPriceBounds();
}

/// [ProductRepository] backed by the Supabase `products` table
/// (`id, name, description, price, stock, image_url, category_id`), with the
/// category name joined in from `categories`.
class SupabaseProductRepository implements ProductRepository {
  SupabaseProductRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _table = 'products';
  static const _columns = '*, categories(name)';

  @override
  Future<ProductPage> fetchPage({
    required int page,
    required int pageSize,
    double? minPrice,
    double? maxPrice,
  }) async {
    assert(page >= 0 && pageSize > 0);

    var query = _client.from(_table).select(_columns);
    if (minPrice != null) query = query.gte('price', minPrice);
    if (maxPrice != null) query = query.lte('price', maxPrice);

    // `.range` is inclusive on both ends, so page 0 with size 6 is 0..5.
    final from = page * pageSize;
    final to = from + pageSize - 1;

    // Order by id as a tie-breaker so rows with equal prices never shift
    // between pages.
    final response = await query
        .order('price', ascending: true)
        .order('id', ascending: true)
        .range(from, to)
        .count(CountOption.exact);

    final items = response.data.map(Product.fromMap).toList(growable: false);
    for (final product in items) {
      productCache[product.id] = product;
    }
    return ProductPage(items: items, totalCount: response.count);
  }

  @override
  Future<PriceBounds?> fetchPriceBounds() async {
    final results = await Future.wait([
      _client
          .from(_table)
          .select('price')
          .order('price', ascending: true)
          .limit(1)
          .maybeSingle(),
      _client
          .from(_table)
          .select('price')
          .order('price', ascending: false)
          .limit(1)
          .maybeSingle(),
    ]);
    final cheapest = results[0];
    final priciest = results[1];
    if (cheapest == null || priciest == null) return null;
    return PriceBounds(
      min: (cheapest['price'] as num).toDouble(),
      max: (priciest['price'] as num).toDouble(),
    );
  }
}

/// Products seen in fetched pages, keyed by id, so detail pages can show
/// products that exist in Supabase but not in the bundled catalogue.
final Map<String, Product> productCache = <String, Product>{};
