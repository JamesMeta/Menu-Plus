import 'package:flutter/material.dart';

class ShowRatingInfoDialog extends StatelessWidget {
  const ShowRatingInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Rating Information"),
      content: Text(
        "Ratings are calculated based on the average score given by group members. Each member can rate a recipe from 1 to 5 stars, and the overall rating is displayed as an average of all ratings received.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Close"),
        ),
      ],
    );
  }
}
