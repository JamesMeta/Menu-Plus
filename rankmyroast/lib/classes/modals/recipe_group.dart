class RecipeGroup {
  final String id;
  final String recipeId;
  final String groupId;

  RecipeGroup({
    required this.id,
    required this.recipeId,
    required this.groupId,
  });

  factory RecipeGroup.fromMap(Map<String, dynamic> map) {
    return RecipeGroup(
      id: map['id'] ?? '',
      recipeId: map['recipe_id'] ?? '',
      groupId: map['group_id'] ?? '',
    );
  }
}
