import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:rankmyroast/classes/modals/recipe_rating.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeViewer extends StatefulWidget {
  final Recipe? recipe;
  final Group? group;

  const RecipeViewer({super.key, this.recipe, this.group});

  @override
  State<RecipeViewer> createState() => _RecipeViewerState();
}

class _RecipeViewerState extends State<RecipeViewer> {
  late final bool _isOwner;
  late final Recipe _recipe;
  late final Group? _group;
  late final String? _recipeImageUrl;

  late final Future<List<RecipeRating>?> _ratings;

  @override
  void initState() {
    _recipe = widget.recipe!;
    _recipeImageUrl = _recipe.publicImageUrl;
    _group = widget.group;

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
          _isOwner
              ? IconButton(
                onPressed: () {
                  //TODO
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
                _recipeImageUrl != null
                    ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: CachedNetworkImage(
                        httpHeaders: {
                          'Authorization':
                              'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
                        },
                        imageUrl: _recipeImageUrl,
                        scale: 1,
                        placeholder:
                            (context, url) => const CircularProgressIndicator(),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      ),
                    )
                    : Image.asset(
                      "assets/images/rankmyroast_icon4.png",
                      scale: 1,
                    ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        _recipe.name,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

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
                              return Text("No reviews yet");
                            } else {
                              if (_group != null) {
                                if (_group.useRating) {
                                  final averageRating =
                                      ratings
                                          .where(
                                            (r) => r.recipeId == _recipe.id,
                                          )
                                          .map((r) => r.rating)
                                          .reduce((a, b) => a + b) /
                                      ratings.length;

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.star, color: Colors.amber),
                                      SizedBox(width: 4),
                                      Text(
                                        averageRating.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  final groupRecipeRankings = <String, int>{};
                                  for (var rating in ratings) {
                                    if (groupRecipeRankings.containsKey(
                                      rating.recipeId,
                                    )) {
                                      groupRecipeRankings[rating.recipeId] =
                                          groupRecipeRankings[rating
                                              .recipeId]! +
                                          rating.ranking;
                                    } else {
                                      groupRecipeRankings[rating.recipeId] =
                                          rating.ranking;
                                    }
                                  }

                                  final sortedRecipeRankings =
                                      groupRecipeRankings.entries.toList()
                                        ..sort(
                                          (a, b) => b.value.compareTo(a.value),
                                        );

                                  final recipeRanking =
                                      sortedRecipeRankings.indexWhere(
                                        (entry) => entry.key == _recipe.id,
                                      ) +
                                      1;
                                  return Text(
                                    "Ranked #$recipeRanking in group",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
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

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey[600]!),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Estimated Preparation Time: ",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),

                                  Text(
                                    "???",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Estimated Cook Time: ",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),

                                  Text(
                                    "???",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Ingredients",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _recipe.ingredientList.length,
                        itemBuilder: (context, index) {
                          final ingredient = _recipe.ingredientList[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ingredient,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      Text(
                        "Instructions",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _recipe.instructionsList.length,
                        itemBuilder: (context, index) {
                          final instruction = _recipe.instructionsList[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${index + 1}. $instruction",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
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
