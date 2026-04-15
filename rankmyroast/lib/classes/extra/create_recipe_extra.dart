import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';

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
