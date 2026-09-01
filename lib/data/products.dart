import 'package:cs_elective_2/models/product.dart';

const products = <Product>[
  Product(
    id: 'apple',
    name: 'Honeycrisp Apple',
    price: 3.49,
    imageUrl:
        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=400&fit=crop',
    description:
        'Crisp, juicy apples picked at peak ripeness. Perfect for snacking or baking.',
    category: 'Tree Fruits',
  ),
  Product(
    id: 'banana',
    name: 'Organic Bananas',
    price: 1.99,
    imageUrl:
        'https://images.unsplash.com/photo-1571771890050-41145a5a046?w=400&h=400&fit=crop',
    description:
        'Sweet, energy-rich bananas sourced from sustainable farms.',
    category: 'Tropical',
  ),
  Product(
    id: 'orange',
    name: 'Valencia Oranges',
    price: 4.29,
    imageUrl:
        'https://images.unsplash.com/photo-1547514700-2cf38111325f?w=400&h=400&fit=crop',
    description:
        'Sun-ripened oranges bursting with vitamin C and natural sweetness.',
    category: 'Citrus',
  ),
  Product(
    id: 'grape',
    name: 'Seedless Grapes',
    price: 5.99,
    imageUrl:
        'https://images.unsplash.com/photo-1537640538964-79a3444c4259?w=400&h=400&fit=crop',
    description:
        'Plump, seedless grape clusters — ideal for lunchboxes and charcuterie.',
    category: 'Berries & Clusters',
  ),
  Product(
    id: 'watermelon',
    name: 'Mini Watermelon',
    price: 6.49,
    imageUrl:
        'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400&h=400&fit=crop',
    description:
        'Refreshing and hydrating — the perfect summer treat for the whole family.',
    category: 'Melons',
  ),
  Product(
    id: 'strawberry',
    name: 'Fresh Strawberries',
    price: 4.99,
    imageUrl:
        'https://images.unsplash.com/photo-1464965911861-746a3542805c?w=400&h=400&fit=crop',
    description:
        'Bright red strawberries with a naturally sweet flavor and firm texture.',
    category: 'Berries & Clusters',
  ),
  Product(
    id: 'mango',
    name: 'Ataulfo Mango',
    price: 2.79,
    imageUrl:
        'https://images.unsplash.com/photo-1553279768-8650fa94810f?w=400&h=400&fit=crop',
    description:
        'Buttery, golden mangoes with minimal fiber and maximum tropical flavor.',
    category: 'Tropical',
  ),
  Product(
    id: 'pineapple',
    name: 'Golden Pineapple',
    price: 5.49,
    imageUrl:
        'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=400&h=400&fit=crop',
    description:
        'Tropical sweetness in every slice — great for smoothies and grilling.',
    category: 'Tropical',
  ),
];

Product? productById(String id) {
  for (final product in products) {
    if (product.id == id) {
      return product;
    }
  }
  return null;
}
