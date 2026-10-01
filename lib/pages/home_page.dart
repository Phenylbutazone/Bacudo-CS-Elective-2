import 'package:cs_elective_2/data/pokemon_service.dart';
import 'package:cs_elective_2/models/pokemon.dart';
import 'package:cs_elective_2/state/theme_notifier.dart';
import 'package:cs_elective_2/widgets/wired/wired_ui.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.service});

  final PokemonService? service;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PokemonService _service;
  late Future<List<Pokemon>> _pokemonFuture;
  bool _ownsService = false;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? PokemonService();
    _ownsService = widget.service == null;
    _pokemonFuture = _service.fetchPokemon();
  }

  @override
  void dispose() {
    if (_ownsService) _service.close();
    super.dispose();
  }

  void _retry() {
    setState(() => _pokemonFuture = _service.fetchPokemon());
  }

  int _columnCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return WiredScaffold(
          appBar: WiredAppBar(
            title: 'Pokédex',
            actions: [
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              final columns = _columnCount(constraints.maxWidth);

              return FutureBuilder<List<Pokemon>>(
                future: _pokemonFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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

                  if (snapshot.hasError) {
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
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: _retry,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final pokemon = snapshot.data ?? const <Pokemon>[];
                  if (pokemon.isEmpty) {
                    return const Center(child: Text('No Pokémon found.'));
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.78,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _PokemonTile(pokemon: pokemon[index]),
                            childCount: pokemon.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _PokemonTile extends StatelessWidget {
  const _PokemonTile({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WiredPanel(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
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
          const SizedBox(height: 8),
          Text(
            '#${pokemon.id.toString().padLeft(3, '0')}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _displayName(pokemon.name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

    String _displayName(String name) => name
      .replaceFirst(RegExp(r'-(altered|50)$'), '')
      .split('-')
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
