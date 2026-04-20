import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeViewer extends StatefulWidget {
  final Recipe? recipe;

  const RecipeViewer({super.key, this.recipe});

  @override
  State<RecipeViewer> createState() => _RecipeViewerState();
}

class _RecipeViewerState extends State<RecipeViewer> {
  late final bool _isOwner;
  late final Recipe _recipe;
  late final String? _recipeImageUrl;

  @override
  void initState() {
    _recipe = widget.recipe!;
    _recipeImageUrl = _recipe.publicImageUrl;

    _isOwner = _recipe.userId == Supabase.instance.client.auth.currentUser!.id;
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

                      Text(
                        "Instructions",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
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
}
