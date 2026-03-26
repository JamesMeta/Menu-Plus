import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/recipe.dart';

class CreateRecipeExtra {
  Group? selectedGroup;
  List<Group> groups;
  Recipe? recipeToEdit;

  CreateRecipeExtra({
    this.selectedGroup,
    this.recipeToEdit,
    required this.groups,
  });
}
