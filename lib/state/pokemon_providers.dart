import 'package:cs_elective_2/data/pokemon_service.dart';
import 'package:cs_elective_2/models/pokemon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The API client. Owned by Riverpod so it is closed when the scope is
/// disposed, and overridable in tests with a mocked HTTP client.
final pokemonServiceProvider = Provider<PokemonService>((ref) {
  final service = PokemonService();
  ref.onDispose(service.close);
  return service;
});

// ─── Pokémon list ──────────────────────────────────────────────────────────

/// Loads the Pokémon list. Its state is an [AsyncValue], so the UI can tell
/// loading, data and error apart.
class PokemonListNotifier extends AsyncNotifier<List<Pokemon>> {
  /// Runs once when the provider is first read: the initial fetch.
  @override
  Future<List<Pokemon>> build() =>
      ref.read(pokemonServiceProvider).fetchPokemon();

  /// Re-runs the same fetch. Used by pull-to-refresh, the refresh button and
  /// the error view's retry button.
  Future<void> fetch() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(pokemonServiceProvider).fetchPokemon(),
    );
  }
}

final pokemonListProvider =
    AsyncNotifierProvider<PokemonListNotifier, List<Pokemon>>(
      PokemonListNotifier.new,
      // Show the error to the user instead of Riverpod's automatic retries.
      retry: (retryCount, error) => null,
    );

// ─── Nicknames ─────────────────────────────────────────────────────────────

/// Custom nicknames keyed by Pokémon id. The original name is never changed.
class NicknamesNotifier extends Notifier<Map<int, String>> {
  @override
  Map<int, String> build() => const {};

  /// Saves [nickname] for [pokemonId]. A blank nickname removes it.
  void setNickname(int pokemonId, String nickname) {
    final trimmed = nickname.trim();
    if (trimmed.isEmpty) {
      removeNickname(pokemonId);
      return;
    }
    // Assign a new map so listeners see a changed state.
    state = {...state, pokemonId: trimmed};
  }

  void removeNickname(int pokemonId) {
    if (!state.containsKey(pokemonId)) return;
    state = {...state}..remove(pokemonId);
  }
}

final nicknamesProvider = NotifierProvider<NicknamesNotifier, Map<int, String>>(
  NicknamesNotifier.new,
);

// ─── Favorites ─────────────────────────────────────────────────────────────

/// Ids of favorite Pokémon, in the order they were added.
class FavoritesNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => const {};

  bool isFavorite(int pokemonId) => state.contains(pokemonId);

  void add(int pokemonId) => state = {...state, pokemonId};

  void remove(int pokemonId) => state = {...state}..remove(pokemonId);

  void toggle(int pokemonId) =>
      isFavorite(pokemonId) ? remove(pokemonId) : add(pokemonId);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);

/// Favorite Pokémon objects, derived from the list and the favorite ids.
/// Rebuilds whenever either one changes, so the favorites panel stays current.
final favoritePokemonProvider = Provider<List<Pokemon>>((ref) {
  final pokemon = ref.watch(pokemonListProvider).value ?? const <Pokemon>[];
  final favoriteIds = ref.watch(favoritesProvider);
  final byId = {for (final entry in pokemon) entry.id: entry};
  return [for (final id in favoriteIds) ?byId[id]];
});

/// Whether the favorites panel is expanded. Kept in app state so it stays
/// open or closed as the user moves between pages.
class FavoritesPanelNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void collapse() => state = false;
}

final favoritesPanelProvider = NotifierProvider<FavoritesPanelNotifier, bool>(
  FavoritesPanelNotifier.new,
);

// ─── Type filter ───────────────────────────────────────────────────────────

/// The selected type, or `null` when every Pokémon is shown.
class TypeFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String type) => state = type;

  void clear() => state = null;
}

final typeFilterProvider = NotifierProvider<TypeFilterNotifier, String?>(
  TypeFilterNotifier.new,
);

/// Every type present in the loaded list, sorted alphabetically.
final availableTypesProvider = Provider<List<String>>((ref) {
  final pokemon = ref.watch(pokemonListProvider).value ?? const <Pokemon>[];
  return {for (final entry in pokemon) ...entry.types}.toList()..sort();
});

/// The loaded list narrowed down to the selected type.
final filteredPokemonProvider = Provider<List<Pokemon>>((ref) {
  final pokemon = ref.watch(pokemonListProvider).value ?? const <Pokemon>[];
  final type = ref.watch(typeFilterProvider);
  if (type == null) return pokemon;
  return pokemon.where((entry) => entry.types.contains(type)).toList();
});
