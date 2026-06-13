import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeListTileWidget extends StatelessWidget {
  final Recipe recipe;
  final String ranking;
  final bool isEdit;

  const RecipeListTileWidget({
    super.key,
    required this.recipe,
    required this.ranking,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final recipeImageUrl = recipe.publicImageUrl;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[600]!),
          color:
              isEdit ? const Color.fromARGB(255, 102, 199, 105) : Colors.green,
          boxShadow: [BoxShadow(color: Colors.grey)],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Large Custom Leading Image
              SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      recipeImageUrl != null
                          ? CachedNetworkImage(
                            httpHeaders: {
                              'Authorization':
                                  'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
                            },
                            imageUrl: recipeImageUrl,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          )
                          : Image.asset(
                            "assets/images/rankmyroast_icon4.png",
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              const SizedBox(width: 16), // Spacing between image and text
              // Title area expands to take up remaining space
              Expanded(
                flex: 7,
                child: Text(
                  recipe.name,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14.sp,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Trailing ranking
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Ranking",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Text(
                          ranking,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
