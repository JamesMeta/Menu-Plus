import 'package:flutter/material.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/recipe.dart';

class CreateRecipeScreen extends StatefulWidget {
  final Recipe? recipeToEdit;
  final Group? selectedGroup;
  final List<Group> groups;

  const CreateRecipeScreen({
    super.key,
    this.recipeToEdit,
    this.selectedGroup,
    required this.groups,
  });

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
