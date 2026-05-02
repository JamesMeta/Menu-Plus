import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rankmyroast/classes/extra/create_recipe_extra.dart';
import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:rankmyroast/classes/modals/recipe_rating.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/viewer/widgets/recipe_list_widget.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeViewer extends StatefulWidget {
  final Recipe? recipe;
  final Group? group;
  final List<Group>? userGroups;

  const RecipeViewer({super.key, this.recipe, this.group, this.userGroups});

  @override
  State<RecipeViewer> createState() => _RecipeViewerState();
}

class _RecipeViewerState extends State<RecipeViewer> {
  late final bool _isOwner;
  late final Recipe _recipe;
  late final Group? _group;
  late final List<Group>? _userGroups;
  late final String? _recipeImageUrl;

  late final Future<List<RecipeRating>?> _ratings;

  @override
  void initState() {
    _recipe = widget.recipe!;
    _recipeImageUrl = _recipe.publicImageUrl;
    _group = widget.group;
    _userGroups = widget.userGroups;

    _isOwner = _recipe.userId == Supabase.instance.client.auth.currentUser!.id;
    _ratings = _fetchRatings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          _isOwner && _userGroups != null
              ? IconButton(
                onPressed: () {
                  context.pushReplacement(
                    "/base/create-recipe",
                    extra: CreateRecipeExtra(
                      recipeToEdit: _recipe,
                      selectedGroup: _group,
                      groups: _userGroups,
                    ),
                  );
                },
                icon: Icon(Icons.edit),
              )
              : SizedBox(),
          IconButton(
            onPressed: () {
              //TODO
            },
            icon: Icon(Icons.copy),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(115, 0, 0, 0),
                  blurRadius: 10,
                  offset: Offset(2, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child:
                        _recipeImageUrl != null
                            ? Container(
                              constraints: BoxConstraints(
                                maxHeight: 300.h,
                                maxWidth: double.infinity,
                              ),

                              child: CachedNetworkImage(
                                httpHeaders: {
                                  'Authorization':
                                      'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
                                },
                                imageUrl: _recipeImageUrl,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: 250.h,

                                placeholder:
                                    (context, url) =>
                                        const CircularProgressIndicator(),
                                errorWidget:
                                    (context, url, error) =>
                                        const Icon(Icons.error),
                              ),
                            )
                            : Container(
                              constraints: BoxConstraints(
                                maxHeight: 250.h,
                                maxWidth: double.infinity,
                              ),
                              child: Image.asset(
                                "assets/images/rankmyroast_icon4.png",
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: 250.h,
                              ),
                            ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _recipe.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 12),

                      FutureBuilder(
                        future: _ratings,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final ratings = snapshot.data;
                            if (ratings == null || ratings.isEmpty) {
                              return Text(
                                "No reviews yet",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              if (_group != null) {
                                if (_group.useRating && ratings.isNotEmpty) {
                                  // 1. Filter for specific recipe and non-null ratings once
                                  final recipeRatings = ratings.where(
                                    (r) =>
                                        r.recipeId == _recipe.id &&
                                        r.rating != null,
                                  );

                                  // 2. Calculate average safely
                                  final averageRating =
                                      recipeRatings.isEmpty
                                          ? 0.0
                                          : recipeRatings.fold<double>(
                                                0,
                                                (sum, r) => sum + r.rating!,
                                              ) /
                                              recipeRatings.length;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${averageRating.toStringAsFixed(1)} / 10 (${recipeRatings.length} ratings)",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  final averages = <String, double>{};
                                  final counts = <String, int>{};

                                  for (var r in ratings) {
                                    final val = r.ranking?.toDouble() ?? 0.0;
                                    averages.update(
                                      r.recipeId,
                                      (curr) => curr + val,
                                      ifAbsent: () => val,
                                    );
                                    counts.update(
                                      r.recipeId,
                                      (curr) => curr + 1,
                                      ifAbsent: () => 1,
                                    );
                                  }

                                  // 2. Map to averages and sort descending (highest score = Rank #1)
                                  final sortedIds =
                                      averages.keys.toList()..sort((a, b) {
                                        final avgA = averages[a]! / counts[a]!;
                                        final avgB = averages[b]! / counts[b]!;
                                        return avgA.compareTo(avgB);
                                      });

                                  // 3. Find rank (1-indexed)
                                  final rank =
                                      sortedIds.indexOf(_recipe.id) + 1;

                                  return Text(
                                    rank == 1
                                        ? "Top Ranked Recipe!"
                                        : "Standing: #$rank of ${sortedIds.length} Recipes",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          rank == 1
                                              ? Colors.green
                                              : Colors.grey[600],
                                    ),
                                  );
                                }
                              } else {
                                return Text("Error: Group not found");
                              }
                            }
                          } else {
                            return Text("Error fetching ratings");
                          }
                        },
                      ),

                      SizedBox(height: 12),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.timer, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Prep",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        _recipe.prepTime != null
                                            ? "${_recipe.prepTime} mins"
                                            : "???",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(width: 100.w),

                              Row(
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Cook",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        _recipe.cookTime != null
                                            ? "${_recipe.cookTime} mins"
                                            : "???",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      Divider(color: Colors.grey[600]),

                      SizedBox(height: 12),
                      Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      RecipeListWidget(
                        itemList: _recipe.ingredientList,
                        numbered: false,
                      ),
                      SizedBox(height: 12),

                      Divider(color: Colors.grey[600]),

                      SizedBox(height: 12),
                      Text(
                        "Instructions",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      RecipeListWidget(
                        itemList: _recipe.instructionsList,
                        numbered: true,
                      ),

                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<RecipeRating>?> _fetchRatings() async {
    final groupId = widget.group?.id;
    final recipeId = widget.recipe?.id;

    if (groupId == null || recipeId == null) {
      return null;
    }

    final response = await SupabaseHelper.recipe.getRatingsByGroupId(groupId);

    return response;
  }
}
