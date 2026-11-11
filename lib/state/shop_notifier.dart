import 'package:cs_elective_2/data/product_repository.dart';
import 'package:cs_elective_2/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show RangeValues;

/// Holds the product listing state: the price filter, the current page and
/// the products on it, plus loading and error flags.
///
/// Every page change or filter change sends a new Supabase query. Only the
/// response to the latest request is applied, so a slow earlier request
/// can't overwrite newer results.
class ShopNotifier extends ChangeNotifier {
  ShopNotifier(this._repository, {this.pageSize = defaultPageSize})
    : assert(pageSize > 0);

  static const int defaultPageSize = 6;

  final ProductRepository _repository;
  final int pageSize;

  /// Cheapest and priciest product, rounded out to whole units. These are the
  /// slider's outer limits. `null` until [load] finishes (or if the
  /// catalogue is empty).
  RangeValues? priceBounds;

  /// The price range currently applied to the query.
  RangeValues? priceRange;

  /// 0-based index of the page shown.
  int page = 0;
  List<Product> items = const [];
  int totalCount = 0;

  bool isLoading = false;
  Object? error;

  int _requestId = 0;

  /// Page of the most recent request, so [retry] repeats the page that
  /// failed rather than the one still on screen.
  int _requestedPage = 0;
  bool _disposed = false;

  int get totalPages => totalCount == 0 ? 0 : (totalCount / pageSize).ceil();
  bool get hasPreviousPage => page > 0;
  bool get hasNextPage => (page + 1) * pageSize < totalCount;

  /// Whether [priceRange] narrows the catalogue at all.
  bool get isFiltered =>
      priceRange != null && priceBounds != null && priceRange != priceBounds;

  /// Loads the price bounds and then the first page. Also used to retry
  /// after the price bounds failed to load.
  Future<void> load() async {
    final requestId = ++_requestId;
    isLoading = true;
    error = null;
    _notify();

    try {
      final bounds = await _repository.fetchPriceBounds();
      if (requestId != _requestId) return;
      if (bounds == null) {
        priceBounds = null;
        priceRange = null;
        page = 0;
        items = const [];
        totalCount = 0;
        isLoading = false;
        _notify();
        return;
      }
      final min = bounds.min.floorToDouble();
      var max = bounds.max.ceilToDouble();
      if (max <= min) max = min + 1; // RangeSlider needs min < max.
      priceBounds = RangeValues(min, max);
      priceRange = priceBounds;
    } catch (e) {
      if (requestId != _requestId) return;
      error = e;
      isLoading = false;
      _notify();
      return;
    }

    await _fetch(0);
  }

  /// Applies a new price filter and jumps back to the first page.
  Future<void> applyPriceRange(RangeValues range) {
    final bounds = priceBounds;
    if (bounds != null) {
      range = RangeValues(
        range.start.clamp(bounds.start, bounds.end),
        range.end.clamp(bounds.start, bounds.end),
      );
    }
    if (range == priceRange && error == null) return Future.value();
    priceRange = range;
    return _fetch(0);
  }

  /// Removes the price filter and jumps back to the first page.
  Future<void> resetPriceRange() {
    final bounds = priceBounds;
    if (bounds == null) return Future.value();
    return applyPriceRange(bounds);
  }

  Future<void> nextPage() =>
      hasNextPage ? _fetch(page + 1) : Future<void>.value();

  Future<void> previousPage() =>
      hasPreviousPage ? _fetch(page - 1) : Future<void>.value();

  Future<void> goToPage(int target) {
    if (target < 0 || (totalPages > 0 && target >= totalPages)) {
      return Future.value();
    }
    return _fetch(target);
  }

  /// Retries whatever failed last: the price bounds or the current page.
  Future<void> retry() =>
      priceBounds == null ? load() : _fetch(_requestedPage);

  Future<void> _fetch(int targetPage) async {
    final requestId = ++_requestId;
    _requestedPage = targetPage;
    isLoading = true;
    error = null;
    _notify();

    try {
      final result = await _repository.fetchPage(
        page: targetPage,
        pageSize: pageSize,
        minPrice: priceRange?.start,
        maxPrice: priceRange?.end,
      );
      if (requestId != _requestId) return;

      // The catalogue may have shrunk since the last count; if the page we
      // asked for is now past the end, fall back to the last page.
      if (result.items.isEmpty && targetPage > 0 && result.totalCount > 0) {
        final lastPage = (result.totalCount / pageSize).ceil() - 1;
        await _fetch(lastPage);
        return;
      }

      page = targetPage;
      items = result.items;
      totalCount = result.totalCount;
      isLoading = false;
      _notify();
    } catch (e) {
      if (requestId != _requestId) return;
      error = e;
      isLoading = false;
      _notify();
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
