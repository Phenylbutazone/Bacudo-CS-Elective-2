import 'package:cs_elective_2/models/product.dart';
import 'package:flutter/material.dart';

/// Cart state — quantities and totals update reactively via [ChangeNotifier].
class CartNotifier extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  int get totalItemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get grandTotal =>
      _items.values.fold(0, (sum, item) => sum + item.subtotal);

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  int quantityFor(Product product) => _items[product.id]?.quantity ?? 0;

  void addProduct(Product product) {
    final existing = _items[product.id];
    if (existing != null) {
      _items[product.id] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void increment(Product product) => addProduct(product);

  void decrement(Product product) {
    final existing = _items[product.id];
    if (existing == null) return;

    if (existing.quantity <= 1) {
      _items.remove(product.id);
    } else {
      _items[product.id] =
          existing.copyWith(quantity: existing.quantity - 1);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.remove(product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

final cartNotifier = CartNotifier();
