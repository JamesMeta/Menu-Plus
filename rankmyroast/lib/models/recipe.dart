class Recipe {
  final String id;
  final String name;
  final String imageName;
  final String userId;
  final List<String> ingredientList;
  final List<String> instructionsList;
  final List<String> groceriesList;
  final bool isPublic;

  Recipe({
    required this.id,
    required this.name,
    required this.imageName,
    required this.userId,
    required this.ingredientList,
    required this.instructionsList,
    required this.groceriesList,
    required this.isPublic,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Untitled Recipe',
      imageName: map['image_name'] ?? '',
      userId: map['user_id'] ?? '',
      ingredientList: List<String>.from(map['ingredients'] ?? []),
      instructionsList: List<String>.from(map['instructions'] ?? []),
      groceriesList: List<String>.from(map['groceries'] ?? []),
      isPublic: map['is_public'] ?? false,
    );
  }
}

extension RecipeImageUrl on Recipe {
  String get publicImageUrl {
    if (imageName == null || imageName!.isEmpty) {
      return 'https://mysite.com/placeholder.png';
    }

    return 'https://ozmzpnayygajicxafxfm.supabase.co/storage/v1/object/public/public_recipe_image/$imageName';
  }
}
