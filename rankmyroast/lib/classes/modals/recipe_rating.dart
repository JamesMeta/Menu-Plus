class RecipeRating {
  final String id;
  final String createdAt;
  final String recipeId;
  final String userId;
  final String groupId;
  final double rating;
  final int ranking;

  RecipeRating({
    required this.id,
    required this.createdAt,
    required this.recipeId,
    required this.userId,
    required this.groupId,
    required this.rating,
    required this.ranking,
  });
}
