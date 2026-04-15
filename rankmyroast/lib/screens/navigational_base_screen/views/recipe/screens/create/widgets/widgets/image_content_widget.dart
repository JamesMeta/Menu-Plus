import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageContentWidget extends StatelessWidget {
  final File? recipeImage;
  final VoidCallback updateRecipeImage;

  final bool isEditing;
  final bool removeImage;
  final String? recipeImageUrl;

  const ImageContentWidget({
    super.key,
    required this.recipeImage,
    required this.updateRecipeImage,
    required this.isEditing,
    required this.removeImage,
    this.recipeImageUrl,
  });

  Widget buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(32),
      ),
      child: IconButton(
        icon: const Icon(Icons.camera_alt, size: 48),
        onPressed: updateRecipeImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (recipeImage != null) {
      return GestureDetector(
        onTap: updateRecipeImage,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.file(recipeImage!, fit: BoxFit.cover),
        ),
      );
    }

    if (isEditing && recipeImageUrl != null && !removeImage) {
      return CachedNetworkImage(
        imageUrl: recipeImageUrl!,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => buildPlaceholderIcon(),
      );
    }

    return buildPlaceholderIcon();
  }
}
