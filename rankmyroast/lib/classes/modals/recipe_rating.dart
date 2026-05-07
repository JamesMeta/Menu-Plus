class RecipeRating {
  final String id;
  final String createdAt;
  final String recipeId;
  final String userId;
  final String groupId;
  final double? rating;
  final int? ranking;

  RecipeRating({
    required this.id,
    required this.createdAt,
    required this.recipeId,
    required this.userId,
    required this.groupId,
    this.rating,
    this.ranking,
  });

  factory RecipeRating.fromMap(Map<String, dynamic> map) {
    return RecipeRating(
      id: map['id'] ?? '',
      createdAt: map['created_at'] ?? '',
      recipeId: map['recipe_id'] ?? '',
      userId: map['user_id'] ?? '',
      groupId: map['group_id'] ?? '',
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      ranking: map['ranking'],
    );
  }
}
