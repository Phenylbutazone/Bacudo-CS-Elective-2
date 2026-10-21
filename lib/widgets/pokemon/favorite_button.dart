import 'package:cs_elective_2/state/pokemon_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Heart icon that shows and toggles a Pokémon's favorite status.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.pokemonId, this.size = 20});

  final int pokemonId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // `select` rebuilds this button only when *this* Pokémon's status changes.
    final isFavorite = ref.watch(
      favoritesProvider.select((ids) => ids.contains(pokemonId)),
    );

    return IconButton(
      visualDensity: VisualDensity.compact,
      iconSize: size,
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.redAccent : null,
      ),
      onPressed: () => ref.read(favoritesProvider.notifier).toggle(pokemonId),
    );
  }
}
