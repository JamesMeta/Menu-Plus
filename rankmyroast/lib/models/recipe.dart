class Recipe {
  final String id;
  final String name;
  final String? avatarUrl;

  Recipe({required this.id, required this.name, this.avatarUrl});

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Untitled Recipe',
      avatarUrl: map['avatar_url'],
    );
  }
}
