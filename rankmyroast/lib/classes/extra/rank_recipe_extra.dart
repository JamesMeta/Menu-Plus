import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:rankmyroast/classes/modals/recipe_rating.dart';

class RankRecipeExtra {
  final List<RecipeRating>? ratings;

  final Recipe? recipeToRank;
  RankRecipeExtra({this.ratings, this.recipeToRank});
}
