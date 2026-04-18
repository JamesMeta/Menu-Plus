import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child:
                      _recipeImageUrl != null
                          ? CachedNetworkImage(
                            httpHeaders: {
                              'Authorization':
                                  'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
                            },
                            imageUrl: _recipeImageUrl,
                            fit: BoxFit.fitWidth,
                            placeholder:
                                (context, url) =>
                                    const CircularProgressIndicator(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          )
                          : Image.asset("assets/images/rankmyroast_icon4.png"),
                ),

                Text("Recipe"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
