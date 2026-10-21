import 'package:cs_elective_2/models/pokemon.dart';
import 'package:cs_elective_2/state/pokemon_providers.dart';
import 'package:cs_elective_2/widgets/pokemon/favorite_button.dart';
import 'package:cs_elective_2/widgets/pokemon/nickname_editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App bar action that expands or collapses the favorites panel.
class FavoritesPanelToggle extends ConsumerWidget {
  const FavoritesPanelToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(favoritesPanelProvider);
    final count = ref.watch(favoritesProvider.select((ids) => ids.length));

    return IconButton(
      tooltip: isExpanded ? 'Hide favorites' : 'Show favorites',
      onPressed: ref.read(favoritesPanelProvider.notifier).toggle,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: Icon(isExpanded ? Icons.favorite : Icons.favorite_border),
      ),
    );
  }
}

/// Collapsible strip listing favorite Pokémon. Shown under the app bar of
/// every [WiredScaffold], so it is reachable from anywhere in the app.
class FavoritesPanel extends ConsumerWidget {
  const FavoritesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(favoritesPanelProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: isExpanded ? const _FavoritesContent() : const SizedBox.shrink(),
    );
  }
}

class _FavoritesContent extends ConsumerWidget {
  const _FavoritesContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoritePokemonProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 4, 4, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '# Favorites (${favorites.length})',
                  style: theme.textTheme.labelLarge,
                ),
              ),
              IconButton(
                tooltip: 'Collapse',
                icon: const Icon(Icons.expand_less),
                onPressed: ref.read(favoritesPanelProvider.notifier).collapse,
              ),
            ],
          ),
          if (favorites.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
              child: Text(
                'No favorite Pokémon yet. Tap the ♡ on a card to add one.',
                style: theme.textTheme.bodySmall,
              ),
            )
          else
            SizedBox(
              height: 112,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 12),
                itemCount: favorites.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) =>
                    _FavoriteTile(pokemon: favorites[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class _FavoriteTile extends ConsumerWidget {
  const _FavoriteTile({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final nickname = ref.watch(
      nicknamesProvider.select((nicknames) => nicknames[pokemon.id]),
    );

    return InkWell(
      onTap: () => showNicknameEditor(context, pokemon),
      child: Container(
        width: 96,
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      pokemon.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: FavoriteButton(pokemonId: pokemon.id, size: 16),
                  ),
                ],
              ),
            ),
            Text(
              nickname ?? pokemon.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: nickname != null ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
