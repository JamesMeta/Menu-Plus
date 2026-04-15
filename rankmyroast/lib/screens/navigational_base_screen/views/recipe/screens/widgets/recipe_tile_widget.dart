import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rankmyroast/models/recipe.dart';
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

  @override
  void initState() {
    _recipe = widget.recipe;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              httpHeaders: {
                'Authorization':
                    'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
              },
              imageUrl: _recipe.publicImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
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
