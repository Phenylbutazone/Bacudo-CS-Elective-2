class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
  });

  final int id;
  final String name;
  final String imageUrl;

  /// Type names from PokéAPI in slot order, e.g. `['fire', 'flying']`.
  final List<String> types;

  /// Original name formatted for display, e.g. `giratina-altered` → `Giratina`.
  String get displayName => name
      .replaceFirst(RegExp(r'-(altered|50)$'), '')
      .split('-')
      .map(capitalize)
      .join(' ');

  static String capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

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

    final types = (json['types'] as List<dynamic>? ?? const [])
        .map((entry) => (entry as Map<String, dynamic>)['type'])
        .map((type) => (type as Map<String, dynamic>)['name'] as String)
        .toList(growable: false);

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: imageUrl,
      types: types,
    );
  }
}
