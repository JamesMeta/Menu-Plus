import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rankmyroast/classes/modals/recipe.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeTileWidget extends StatefulWidget {
  final Recipe recipe;

  const RecipeTileWidget({super.key, required this.recipe});

  @override
  State<RecipeTileWidget> createState() => _RecipeTileWidgetState();
}

class _RecipeTileWidgetState extends State<RecipeTileWidget> {
  late final Recipe _recipe;
  late final String? _recipeImageUrl;

  @override
  void initState() {
    _recipe = widget.recipe;
    _recipeImageUrl = _recipe.publicImageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => const CircularProgressIndicator(),
                      errorWidget:
                          (context, url, error) => const Icon(Icons.error),
                    )
                    : Image.asset("assets/images/rankmyroast_icon4.png"),
          ),
          Text(
            _recipe.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
