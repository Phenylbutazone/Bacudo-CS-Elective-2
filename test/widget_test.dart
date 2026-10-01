import 'dart:convert';

import 'package:cs_elective_2/data/pokemon_service.dart';
import 'package:cs_elective_2/pages/home_page.dart';
import 'package:flutter/material.dart';
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

  testWidgets('home screen displays Pokémon names and IDs', (
    WidgetTester tester,
  ) async {
    final service = PokemonService(client: _mockPokemonClient());
    addTearDown(service.close);

    await tester.pumpWidget(MaterialApp(home: HomePage(service: service)));
    expect(find.text('Loading Pokémon...'), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.textContaining('Pokédex'), findsOneWidget);
    expect(find.text('Articuno'), findsOneWidget);
    expect(find.text('#144'), findsOneWidget);
  });
}

MockClient _mockPokemonClient({List<String>? requestedNames}) {
  return MockClient((request) async {
    final name = request.url.pathSegments.last;
    requestedNames?.add(name);
    final id = PokemonService.pokemonNames.indexOf(name) + 144;
    return http.Response(
      jsonEncode({
        'id': id,
        'name': name,
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
