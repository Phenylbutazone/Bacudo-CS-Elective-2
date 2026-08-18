class Fruit {
  const Fruit({
    required this.name,
    required this.emoji,
    required this.color,
    required this.description,
  });

  final String name;
  final String emoji;
  final int color;
  final String description;
}

const fruits = <Fruit>[
  Fruit(
    name: 'apple',
    emoji: '🍎',
    color: 0xFFE53935,
    description: 'Crisp and sweet, apples are a classic snack.',
  ),
  Fruit(
    name: 'banana',
    emoji: '🍌',
    color: 0xFFFDD835,
    description: 'Soft and energy-rich, perfect for breakfast.',
  ),
  Fruit(
    name: 'orange',
    emoji: '🍊',
    color: 0xFFFB8C00,
    description: 'Juicy citrus packed with vitamin C.',
  ),
  Fruit(
    name: 'grape',
    emoji: '🍇',
    color: 0xFF8E24AA,
    description: 'Small, sweet clusters great for sharing.',
  ),
  Fruit(
    name: 'watermelon',
    emoji: '🍉',
    color: 0xFF43A047,
    description: 'Refreshing and hydrating on a hot day.',
  ),
];

Fruit? fruitByName(String name) {
  final normalized = name.toLowerCase();
  for (final fruit in fruits) {
    if (fruit.name == normalized) {
      return fruit;
    }
  }
  return null;
}
