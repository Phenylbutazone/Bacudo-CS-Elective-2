class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
  });

  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;

  /// Builds a [Product] from a row of the Supabase `products` table,
  /// selected as `*, categories(name)` so the category name is embedded.
  factory Product.fromMap(Map<String, dynamic> map) {
    final category = map['categories'];
    return Product(
      id: map['id'].toString(),
      name: map['name'] as String? ?? '',
      price: (map['price'] as num).toDouble(),
      imageUrl: map['image_url'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: category is Map ? category['name'] as String? ?? '' : '',
    );
  }
}

class CartItem {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}
