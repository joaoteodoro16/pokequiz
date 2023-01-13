import 'dart:convert';

class Pokemon {
  int id;
  String name;
  String sprite;

  Pokemon({required this.id, required this.name, required this.sprite});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "urlSprite": sprite,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      sprite: map['sprites']['other']['official-artwork']['front_default'] ?? '',
    );
  }

  factory Pokemon.fromJson(String json) => Pokemon.fromMap(jsonDecode(json));
}
