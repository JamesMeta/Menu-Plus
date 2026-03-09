import 'package:flutter/material.dart';

class ShowRankingInfoDialog extends StatelessWidget {
  const ShowRankingInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Ranking Information"),
      content: Text(
        "Rankings are determined by the average rating of all recipes in the group. Each recipe is rated by group members on a scale of 1 to 5 stars, and the overall ranking is calculated based on these ratings.",
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
