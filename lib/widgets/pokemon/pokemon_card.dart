import 'package:cs_elective_2/models/pokemon.dart';
import 'package:cs_elective_2/state/pokemon_providers.dart';
import 'package:cs_elective_2/widgets/pokemon/favorite_button.dart';
import 'package:cs_elective_2/widgets/pokemon/nickname_editor_dialog.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PokemonCard extends ConsumerWidget {
  const PokemonCard({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final nickname = ref.watch(
      nicknamesProvider.select((nicknames) => nicknames[pokemon.id]),
    );

    return InkWell(
      onTap: () => showNicknameEditor(context, pokemon),
      child: WiredPanel(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      pokemon.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: FavoriteButton(pokemonId: pokemon.id),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    pokemon.types.map(Pokemon.capitalize).join(' / '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (nickname != null) ...[
              Text(
                '"$nickname"',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                pokemon.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ] else
              Text(
                pokemon.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
          ],
        ),
      ),
    );
  }
}
