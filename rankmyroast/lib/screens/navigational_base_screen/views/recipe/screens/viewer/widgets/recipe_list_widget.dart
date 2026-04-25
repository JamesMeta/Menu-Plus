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
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 4.h),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final item = itemList[index];
        return Row(
          children: [
            Text(
              numbered ? "${index + 1}. " : "• ",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            Text(item, style: TextStyle(fontSize: 16.sp)),
          ],
        );
      },
    );
  }
}
