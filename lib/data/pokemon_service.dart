import 'dart:convert';

import 'package:cs_elective_2/models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonService {
  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  static const pokemonNames = [
    'articuno',
    'zapdos',
    'moltres',
    'raikou',
    'entei',
    'suicune',
    'regirock',
    'regice',
    'registeel',
    'latias',
    'latios',
    'mewtwo',
    'lugia',
    'ho-oh',
    'kyogre',
    'groudon',
    'rayquaza',
    'dialga',
    'palkia',
    'giratina-altered',
    'reshiram',
    'zekrom',
    'kyurem',
    'xerneas',
    'yveltal',
    'zygarde-50',
    'zacian',
    'zamazenta',
    'eternatus',
    'calyrex',
  ];

  static const resultLimit = 30;

  final http.Client _client;

  Future<List<Pokemon>> fetchPokemon() async {
    final names = pokemonNames.take(resultLimit);
    final pokemon = await Future.wait(names.map(_fetchByName));
    return pokemon;
  }

  Future<Pokemon> _fetchByName(String name) async {
    final uri = Uri.https('pokeapi.co', '/api/v2/pokemon/$name');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw http.ClientException(
        'PokéAPI returned status ${response.statusCode}.',
        uri,
      );
    }

    return Pokemon.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  void close() => _client.close();
}
