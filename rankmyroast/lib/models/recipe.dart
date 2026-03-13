// ignore_for_file: non_constant_identifier_names

class Recipe {
  final String id;
  final String created_at;
  String name;
  String avatar_url;
  String ingredients;
  String instructions;
  bool is_public;
  String user_id;

  Recipe({
    required this.id,
    required this.created_at,
    required this.name,
    required this.avatar_url,
    required this.ingredients,
    required this.instructions,
    required this.is_public,
    required this.user_id,
  });
}
