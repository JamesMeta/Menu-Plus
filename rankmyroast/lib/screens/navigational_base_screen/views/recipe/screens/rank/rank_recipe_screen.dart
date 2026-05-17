import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:rankmyroast/classes/modals/recipe_rating.dart';
import 'package:rankmyroast/classes/modals/group.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/rank/classes/recipe_group_user_ranking.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RankRecipeScreen extends StatefulWidget {
  final List<RecipeRating>? ratings;
  final Group? group;
  final Recipe? recipeToRank;

  const RankRecipeScreen({
    super.key,
    this.ratings,
    this.group,
    this.recipeToRank,
  });

  @override
  State<RankRecipeScreen> createState() => _RankRecipeScreenState();
}

class _RankRecipeScreenState extends State<RankRecipeScreen> {
  late final Future<List<RecipeGroupUserRanking>> _recipeGroupUserRankingList;
  List<RecipeRating>? _ratings;
  Group? _group;
  Recipe? _recipeToRank;

  bool _viewGroupRankings = false;
  bool _modifyRecipeRankings = false;
  bool _reordering = false;

  final List<String> _titles = [
    'Your Rankings',
    'Group Rankings',
    'Edit Group Rankings',
  ];
  int _currentTitleIndex = 0;

  @override
  void initState() {
    _ratings = widget.ratings;
    _group = widget.group;
    _recipeToRank = widget.recipeToRank;
    _recipeGroupUserRankingList = _fetchRecipeGroupUserRankings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          _titles[_currentTitleIndex],
          style: TextStyle(fontSize: 28.sp),
        ),
        foregroundColor: Colors.white,
        actions:
            _group != null
                ? [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_viewGroupRankings) {
                          _currentTitleIndex = 0;
                        } else {
                          _currentTitleIndex = 1;
                          _modifyRecipeRankings = false;
                        }
                        _viewGroupRankings = !_viewGroupRankings;
                      });
                    },
                    icon: Icon(_viewGroupRankings ? Icons.person : Icons.group),
                  ),
                  if (!_viewGroupRankings)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_modifyRecipeRankings) {
                            _currentTitleIndex = 1;
                          } else {
                            _currentTitleIndex = 2;
                          }
                          _modifyRecipeRankings = !_modifyRecipeRankings;
                          _reordering = !_reordering;
                        });
                      },
                      icon: Icon(
                        _modifyRecipeRankings ? Icons.edit_off : Icons.edit,
                      ),
                    ),
                ]
                : null,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: _recipeGroupUserRankingList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No recipes found.'));
                } else {
                  final List<RecipeGroupUserRanking>
                  recipeGroupUserRankingList = snapshot.data!;

                  if (!_reordering) {
                    if (_viewGroupRankings) {
                      recipeGroupUserRankingList.sort((a, b) {
                        final rankingA = a.groupRank;
                        final rankingB = b.groupRank;
                        return rankingA.compareTo(rankingB);
                      });
                    } else {
                      recipeGroupUserRankingList.sort((a, b) {
                        final rankingA = a.userRank;
                        final rankingB = b.userRank;
                        return rankingA.compareTo(rankingB);
                      });
                    }
                  }

                  print(recipeGroupUserRankingList);

                  return !_modifyRecipeRankings
                      ? ListView.builder(
                        itemCount: recipeGroupUserRankingList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final recipe =
                              recipeGroupUserRankingList[index].recipe;
                          return ListTile(
                            title: Text(recipe.name),
                            subtitle: Text(
                              'Prep Time: ${recipe.prepTime} mins',
                            ),
                            trailing: Text(index.toString()),
                          );
                        },
                      )
                      : ReorderableListView.builder(
                        onReorder: (oldIndex, newIndex) {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final movedRecipe = recipeGroupUserRankingList
                              .removeAt(oldIndex);
                          recipeGroupUserRankingList.insert(
                            newIndex,
                            movedRecipe,
                          );
                          setState(() {});
                        },
                        shrinkWrap: true,
                        itemCount: recipeGroupUserRankingList.length,
                        itemBuilder: (context, index) {
                          final recipe =
                              recipeGroupUserRankingList[index].recipe;
                          return ReorderableDragStartListener(
                            key: ValueKey(recipe.id),
                            index: index,

                            child: ListTile(
                              leading: Icon(Icons.drag_handle),
                              title: Text(recipe.name),
                              subtitle: Text(
                                'Prep Time: ${recipe.prepTime} mins',
                              ),
                              trailing: Text(index.toString()),
                            ),
                          );
                        },
                      );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> _sortRecipesByRatings(List<RecipeRating> ratings) {
    final averages = <String, double>{};
    final counts = <String, int>{};

    for (var r in ratings) {
      final val = r.ranking?.toDouble() ?? 0.0;
      averages.update(r.recipeId, (curr) => curr + val, ifAbsent: () => val);
      counts.update(r.recipeId, (curr) => curr + 1, ifAbsent: () => 1);
    }

    final sortedIds =
        averages.keys.toList()..sort((a, b) {
          final avgA = averages[a]! / counts[a]!;
          final avgB = averages[b]! / counts[b]!;
          return avgA.compareTo(avgB);
        });

    return sortedIds;
  }

  List<RecipeGroupUserRanking> _buildRecipeGroupUserRanking(
    List<Recipe> recipes,
    List<RecipeRating> ratings,
    List<RecipeRating> userSpecificRatings,
  ) {
    final groupSortedIds = _sortRecipesByRatings(ratings);
    final userSortedIds = _sortRecipesByRatings(userSpecificRatings);

    final List<RecipeGroupUserRanking> recipeGroupUserRanking =
        recipes.map((r) {
          return RecipeGroupUserRanking(
            userRank:
                userSortedIds.contains(r.id)
                    ? userSortedIds.indexOf(r.id).toDouble()
                    : double.infinity,
            groupRank:
                groupSortedIds.contains(r.id)
                    ? groupSortedIds.indexOf(r.id).toDouble()
                    : double.infinity,
            recipe: r,
          );
        }).toList();

    return recipeGroupUserRanking;
  }

  Future<List<RecipeGroupUserRanking>> _fetchRecipeGroupUserRankings() async {
    final recipes = await SupabaseHelper.recipe.getRecipesByGroupId(
      _group?.id ?? '',
    );

    if (recipes == null) return [];

    late final List<RecipeGroupUserRanking> recipeGroupUserRankingList;

    if (_ratings != null) {
      final userSpecificRatings =
          _ratings!
              .where(
                (r) =>
                    r.userId == Supabase.instance.client.auth.currentUser?.id,
              )
              .toList();

      final ratings = _ratings!;

      recipeGroupUserRankingList = _buildRecipeGroupUserRanking(
        recipes,
        ratings,
        userSpecificRatings,
      );
    } else {
      final ratings = await SupabaseHelper.recipe.getRatingsByGroupId(
        _group?.id ?? '',
      );

      final userSpecificRatings =
          _ratings!
              .where(
                (r) =>
                    r.userId == Supabase.instance.client.auth.currentUser?.id,
              )
              .toList();

      recipeGroupUserRankingList = _buildRecipeGroupUserRanking(
        recipes,
        ratings!,
        userSpecificRatings,
      );
    }

    return recipeGroupUserRankingList;
  }
}
