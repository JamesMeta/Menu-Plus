import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreenTheme {
  //
  // FONTS
  //

  static final titleTextStyle = TextStyle(
    fontSize: 40.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static final creditTextStyle = TextStyle(
    fontSize: 8.spMin,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
  static final sectionTitleStyle = TextStyle(
    fontSize: 28.spMax,
    fontWeight: FontWeight.bold,
  );

  static final textButtonTextStyle = TextStyle(
    decoration: TextDecoration.underline,
    color: Colors.black,
  );

  //
  // TextFields
  //

  static InputDecoration textfieldInputDecoration(final String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(fontSize: 18),

      isCollapsed: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      border: InputBorder.none,
    );
  }

  static final textFieldContainerHeight = 50.h;
  static final textFieldContainerWidth = double.infinity;

  static final textFieldContainerDecoration = BoxDecoration(
    border: Border.all(color: Colors.black),
    borderRadius: BorderRadius.circular(24),
  );

  //
  // Buttons
  //

  static final elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(24),
    ),
    maximumSize: Size(double.infinity, 50.h),
    minimumSize: Size(double.infinity, 50.h),
  );

  static final elevatedGoogleButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(24),
    ),
    maximumSize: Size(double.infinity, 50.h),
    minimumSize: Size(double.infinity, 50.h),
  );

  static final textButtonStyle = TextButton.styleFrom(padding: EdgeInsets.zero);

  static final sizeBoxSpacingHeight = 8.0;
}
