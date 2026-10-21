import 'dart:convert';

import 'package:cs_elective_2/data/pokemon_service.dart';
import 'package:cs_elective_2/pages/home_page.dart';
import 'package:cs_elective_2/state/pokemon_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('fetches no more than 30 Pokémon in the requested order', () async {
    final requestedNames = <String>[];
    final client = _mockPokemonClient(requestedNames: requestedNames);
    final service = PokemonService(client: client);

    final pokemon = await service.fetchPokemon();

    expect(pokemon, hasLength(30));
    expect(
      pokemon.map((entry) => entry.name),
      PokemonService.pokemonNames.take(30),
    );
    expect(requestedNames, contains('giratina-altered'));
    expect(requestedNames, contains('zygarde-50'));
    service.close();
  });

  group('state', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          pokemonServiceProvider.overrideWithValue(
            PokemonService(client: _mockPokemonClient()),
          ),
        ],
      );
    });
    tearDown(() => container.dispose());

    test('nicknames can be set, edited and removed', () {
      final nicknames = container.read(nicknamesProvider.notifier);

      nicknames.setNickname(144, '  Frosty ');
      expect(container.read(nicknamesProvider), {144: 'Frosty'});

      nicknames.setNickname(144, 'Icy');
      expect(container.read(nicknamesProvider), {144: 'Icy'});

      nicknames.setNickname(144, '   ');
      expect(container.read(nicknamesProvider), isEmpty);
    });

    test('favorites toggle and resolve to Pokémon', () async {
      await container.read(pokemonListProvider.future);
      final favorites = container.read(favoritesProvider.notifier);

      favorites.toggle(145);
      expect(
        container.read(favoritePokemonProvider).map((p) => p.name),
        ['zapdos'],
      );

      favorites.toggle(145);
      expect(container.read(favoritePokemonProvider), isEmpty);
    });

    test('type filter narrows and clears the list', () async {
      await container.read(pokemonListProvider.future);
      expect(container.read(availableTypesProvider), ['electric', 'ice']);

      container.read(typeFilterProvider.notifier).select('electric');
      final filtered = container.read(filteredPokemonProvider);
      expect(filtered, hasLength(15));
      expect(filtered.every((p) => p.types.contains('electric')), isTrue);

      container.read(typeFilterProvider.notifier).clear();
      expect(container.read(filteredPokemonProvider), hasLength(30));
    });
  });

  testWidgets('home screen displays Pokémon names and IDs', (tester) async {
    await tester.pumpWidget(_app(_mockPokemonClient()));
    expect(find.text('Loading Pokémon...'), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.textContaining('Pokédex'), findsOneWidget);
    expect(find.text('Articuno'), findsOneWidget);
    expect(find.text('#144'), findsOneWidget);
  });

  testWidgets('shows an error and recovers on retry', (tester) async {
    var fail = true;
    final client = _mockPokemonClient(shouldFail: () => fail);

    await tester.pumpWidget(_app(client));
    await tester.pumpAndSettle();
    expect(find.text('Could not load Pokémon.'), findsOneWidget);

    fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Articuno'), findsOneWidget);
  });

  testWidgets('heart toggles favorite and updates the panel', (tester) async {
    await tester.pumpWidget(_app(_mockPokemonClient()));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Show favorites'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No favorite Pokémon yet'), findsOneWidget);

    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pumpAndSettle();
    expect(find.text('# Favorites (1)'), findsOneWidget);
    expect(find.byTooltip('Remove from favorites'), findsNWidgets(2));
  });

  testWidgets('nickname shows on card alongside original name', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_mockPokemonClient()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Articuno'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Frosty');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('"Frosty"'), findsOneWidget);
    expect(find.text('Articuno'), findsOneWidget);
  });
}

Widget _app(http.Client client) {
  return ProviderScope(
    overrides: [
      pokemonServiceProvider.overrideWithValue(PokemonService(client: client)),
    ],
    child: const MaterialApp(home: HomePage()),
  );
}

MockClient _mockPokemonClient({
  List<String>? requestedNames,
  bool Function()? shouldFail,
}) {
  return MockClient((request) async {
    if (shouldFail?.call() ?? false) return http.Response('oops', 500);
    final name = request.url.pathSegments.last;
    requestedNames?.add(name);
    final index = PokemonService.pokemonNames.indexOf(name);
    final id = index + 144;
    return http.Response(
      jsonEncode({
        'id': id,
        'name': name,
        'types': [
          {
            'slot': 1,
            'type': {'name': index.isEven ? 'ice' : 'electric'},
          },
        ],
        'sprites': {
          'front_default': 'https://example.com/$id.png',
          'other': {
            'official-artwork': {
              'front_default': 'https://example.com/$id.png',
            },
          },
        },
      }),
      200,
      headers: {'content-type': 'application/json'},
    );
  });
}
