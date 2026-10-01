class Pokemon {
  const Pokemon({required this.id, required this.name, required this.imageUrl});

  final int id;
  final String name;
  final String imageUrl;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;
    final other = sprites['other'] as Map<String, dynamic>?;
    final artwork = other?['official-artwork'] as Map<String, dynamic>?;
    final imageUrl =
        artwork?['front_default'] as String? ??
        sprites['front_default'] as String?;

    if (imageUrl == null) {
      throw const FormatException('Pokémon image is missing.');
    }

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: imageUrl,
    );
  }
}
