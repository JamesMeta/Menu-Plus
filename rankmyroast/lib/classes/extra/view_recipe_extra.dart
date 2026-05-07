import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';

class ViewRecipeExtra {
  final Group group;
  final Recipe recipe;
  final List<Group> userGroups;
  ViewRecipeExtra({
    required this.group,
    required this.recipe,
    required this.userGroups,
  });
}
