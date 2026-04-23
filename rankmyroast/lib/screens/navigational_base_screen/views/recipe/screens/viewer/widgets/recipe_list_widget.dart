import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeListWidget extends StatelessWidget {
  final List<String> itemList;
  final bool numbered;

  const RecipeListWidget({
    super.key,
    required this.itemList,
    required this.numbered,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final item = itemList[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${numbered ? "${index + 1}. " : "- "}$item",
              style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
            ),
          ],
        );
      },
    );
  }
}
