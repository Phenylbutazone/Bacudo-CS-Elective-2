import 'package:cs_elective_2/models/pokemon.dart';
import 'package:cs_elective_2/state/pokemon_providers.dart';
import 'package:cs_elective_2/state/theme_notifier.dart';
import 'package:cs_elective_2/widgets/pokemon/pokemon_card.dart';
import 'package:cs_elective_2/widgets/pokemon/type_filter_bar.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonAsync = ref.watch(pokemonListProvider);
    final listNotifier = ref.read(pokemonListProvider.notifier);

    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return WiredScaffold(
          appBar: WiredAppBar(
            title: 'Pokédex',
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: pokemonAsync.isLoading ? null : listNotifier.fetch,
              ),
              IconButton(
                icon: Icon(
                  themeNotifier.isVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                tooltip: themeNotifier.isVisible
                    ? 'Go invisible'
                    : 'Go visible',
                onPressed: themeNotifier.toggle,
              ),
            ],
          ),
          body: switch (pokemonAsync) {
            AsyncValue(:final error?, isLoading: false) => _ErrorView(
              error: error,
              onRetry: listNotifier.fetch,
            ),
            AsyncValue(hasValue: true, isLoading: false) => RefreshIndicator(
              onRefresh: listNotifier.fetch,
              child: const _PokemonGrid(),
            ),
            _ => const _LoadingView(),
          },
        );
      },
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading Pokémon...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40),
            const SizedBox(height: 12),
            const Text('Could not load Pokémon.'),
            const SizedBox(height: 8),
            Text(
              'Check your internet connection and try again.\n($error)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PokemonGrid extends ConsumerWidget {
  const _PokemonGrid();

  int _columnCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(filteredPokemonProvider);
    final selectedType = ref.watch(typeFilterProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnCount(constraints.maxWidth);

        return CustomScrollView(
          // Keeps pull-to-refresh working even when the list is short.
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: TypeFilterBar()),
            if (pokemon.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyView(selectedType: selectedType),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => PokemonCard(
                      key: ValueKey(pokemon[index].id),
                      pokemon: pokemon[index],
                    ),
                    childCount: pokemon.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EmptyView extends ConsumerWidget {
  const _EmptyView({required this.selectedType});

  final String? selectedType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = selectedType;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type == null
                ? 'No Pokémon found.'
                : 'No ${Pokemon.capitalize(type)}-type Pokémon found.',
          ),
          if (type != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: ref.read(typeFilterProvider.notifier).clear,
              child: const Text('Clear filter'),
            ),
          ],
        ],
      ),
    );
  }
}
