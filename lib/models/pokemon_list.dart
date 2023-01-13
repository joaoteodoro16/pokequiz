import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PokemonList {
  
  String name;
  String url;

  PokemonList({
    required this.name,
    required this.url,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
    };
  }

  factory PokemonList.fromMap(Map<String, dynamic> map) {
    return PokemonList(
      name: map['name'] ?? '',
      url: map['url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonList.fromJson(String source) => PokemonList.fromMap(json.decode(source) as Map<String, dynamic>);
}
