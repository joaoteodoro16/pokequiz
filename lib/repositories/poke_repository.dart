import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokequiz/models/pokemon.dart';
import 'package:pokequiz/models/pokemon_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokeRepository {
  Future<Pokemon> searchId(int id) async {
    final pokemonResult =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'));
    return Pokemon.fromJson(pokemonResult.body);
  }

  Future<List<Pokemon>> searchAll() async {
    final allPokemonResult = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=20&limit=50'));
    final listResults = jsonDecode(allPokemonResult.body);

    final allPokeList = listResults['results']
    
        .map<PokemonList>((pokemon) => PokemonList.fromMap(pokemon))
        .toList();
    final List<Pokemon> pokeList = [];


    for (PokemonList poke in allPokeList) {
      final onlyPokemon = await http.get(Uri.parse(poke.url));
      pokeList.add(Pokemon.fromJson(onlyPokemon.body));
    }

    return pokeList;
  }

  Future<void> salvarPontuacao(int pontuacao) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("PONTOS", pontuacao);
  }

  Future<int> pegarPontuacao() async{
    final prefs = await SharedPreferences.getInstance();
    final pontos =  prefs.getInt("PONTOS") ?? 0;
    return pontos;
  }
}
