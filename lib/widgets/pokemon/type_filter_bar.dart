import 'package:cs_elective_2/models/pokemon.dart';
import 'package:cs_elective_2/state/pokemon_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Horizontal chip selector for filtering the list by Pokémon type.
class TypeFilterBar extends ConsumerWidget {
  const TypeFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final types = ref.watch(availableTypesProvider);
    final selected = ref.watch(typeFilterProvider);
    final filter = ref.read(typeFilterProvider.notifier);

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: selected == null,
            onSelected: (_) => filter.clear(),
          ),
          for (final type in types) ...[
            const SizedBox(width: 6),
            ChoiceChip(
              label: Text(Pokemon.capitalize(type)),
              selected: selected == type,
              // Tapping the selected chip again clears the filter.
              onSelected: (isSelected) =>
                  isSelected ? filter.select(type) : filter.clear(),
            ),
          ],
          if (selected != null) ...[
            const SizedBox(width: 6),
            ActionChip(
              avatar: const Icon(Icons.close, size: 16),
              label: const Text('Clear filter'),
              onPressed: filter.clear,
            ),
          ],
        ],
      ),
    );
  }
}
