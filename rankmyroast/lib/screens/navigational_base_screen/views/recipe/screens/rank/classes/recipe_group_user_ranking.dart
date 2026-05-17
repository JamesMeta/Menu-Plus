import 'package:rankmyroast/classes/modals/recipe.dart';

class RecipeGroupUserRanking {
  final double userRank;
  final double groupRank;
  final Recipe recipe;

  RecipeGroupUserRanking({
    required this.userRank,
    required this.groupRank,
    required this.recipe,
  });
}
