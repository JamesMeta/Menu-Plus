import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:rankmyroast/classes/modals/recipe_rating.dart';

class RankRecipeExtra {
  final List<RecipeRating>? ratings;
  final Group? group;
  final Recipe? recipeToRank;
  RankRecipeExtra({this.ratings, this.group, this.recipeToRank});
}
