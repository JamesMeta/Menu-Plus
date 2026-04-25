import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rankmyroast/classes/extra/create_recipe_extra.dart';
import 'package:rankmyroast/classes/extra/view_recipe_extra.dart';
import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/widgets/recipe_tile_widget.dart';
import 'package:rankmyroast/services/supabase_helper.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  bool groupRecipes = true;
  Group? _selectedGroup;

  late Future<List<Group>?> _groupsList;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          FutureBuilder(
            future: _groupsList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Row(
                  children: [
                    Text(
                      "Recipes ",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(0)",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add, color: Colors.white, size: 22.sp),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox();
              } else {
                final groups = snapshot.data ?? [];

                return Row(
                  children: [
                    Text(
                      "Recipes ",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(${_selectedGroup != null ? _selectedGroup!.recipes.length : 0})",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: () async {
                        _navigateToCreateRecipeScreen(groups, null);
                      },
                      icon: Icon(Icons.add, color: Colors.white, size: 22.sp),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          side: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          Row(
            children: [
              FutureBuilder(
                future: _groupsList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    final groups = snapshot.data;

                    if (groups != null) {
                      return DropdownMenu(
                        initialSelection: _selectedGroup,
                        onSelected: (value) {
                          setState(() {
                            _selectedGroup = value;
                          });
                        },
                        dropdownMenuEntries:
                            groups
                                .map(
                                  (group) => DropdownMenuEntry(
                                    value: group,
                                    label: group.name,
                                  ),
                                )
                                .toList(),
                      );
                    } else {
                      return Center(child: Text("The Data is null"));
                    }
                  } else {
                    return Center(child: Text("The Data is never coming"));
                  }
                },
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Expanded(
            child: FutureBuilder(
              future: _groupsList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  final groups = snapshot.data;

                  if (groups != null) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        const double idealItemWidth = 120.0;

                        int crossAxisCount =
                            (constraints.maxWidth / idealItemWidth).floor();

                        if (crossAxisCount < 2) crossAxisCount = 2;

                        return RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              _loadData();
                            });
                          },
                          color: Colors.white, // Color of the spinner
                          backgroundColor: Colors.green,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                            itemCount:
                                _selectedGroup != null
                                    ? _selectedGroup!.recipes.length
                                    : 0,
                            itemBuilder: (context, index) {
                              print(index);
                              final recipe = _selectedGroup!.recipes[index];
                              return GestureDetector(
                                onTap: () {
                                  context.push(
                                    "/base/view-recipe",
                                    extra: ViewRecipeExtra(
                                      group: _selectedGroup!,
                                      recipe: recipe,
                                      userGroups: groups,
                                    ),
                                  );
                                },
                                child: RecipeTileWidget(recipe: recipe),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("The Data is null"));
                  }
                } else {
                  return Center(child: Text("The Data is never coming"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToCreateRecipeScreen(
    List<Group> groups,
    Recipe? recipe,
  ) async {
    final newRecipe = await context.push(
      "/base/create-recipe",
      extra: CreateRecipeExtra(
        groups: groups,
        selectedGroup: _selectedGroup,
        recipeToEdit: recipe,
      ),
    );
  }

  Future<void> _loadData() async {
    _groupsList = SupabaseHelper.groups.getGroupsForUser();
    try {
      _selectedGroup = (await _groupsList)?.first;
    } on Exception {
      _selectedGroup = null;
    }
  }
}
