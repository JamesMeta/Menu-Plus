import 'package:flutter/material.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:rankmyroast/classes/modals/recipe_rating.dart';

class RankRecipeScreen extends StatefulWidget {
  final List<RecipeRating>? ratings;
  final Recipe? recipeToRank;

  const RankRecipeScreen({super.key, this.ratings, this.recipeToRank});

  @override
  State<RankRecipeScreen> createState() => _RankRecipeScreenState();
}

class _RankRecipeScreenState extends State<RankRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
