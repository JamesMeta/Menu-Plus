import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeSectionWidget extends StatefulWidget {
  final String includeSectionText;
  final bool includeSection;
  final bool isHidden;
  final VoidCallback onModify;
  final VoidCallback onHide;
  final TextEditingController controllerPrepTime;
  final TextEditingController controllerCookTime;
  final void Function(void Function()) setParentState;

  const TimeSectionWidget({
    super.key,
    required this.includeSectionText,
    required this.includeSection,
    required this.isHidden,
    required this.onModify,
    required this.onHide,
    required this.controllerPrepTime,
    required this.controllerCookTime,
    required this.setParentState,
  });

  @override
  State<TimeSectionWidget> createState() => _TimeSectionWidgetState();
}

class _TimeSectionWidgetState extends State<TimeSectionWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return !widget.isHidden
        ? widget.includeSection
            ? Column(
              children: [
                ExpansionTile(
                  onExpansionChanged:
                      (value) => setState(() => _isExpanded = value),
                  tilePadding: EdgeInsets.symmetric(horizontal: 8.w),
                  backgroundColor: Colors.green,

                  initiallyExpanded: true,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  iconColor: Colors.white,
                  collapsedIconColor: Colors.grey[600],
                  collapsedBackgroundColor: Colors.white,
                  collapsedTextColor: Colors.grey[600],
                  textColor: Colors.white,
                  leading: IconButton(
                    onPressed: widget.onModify,
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,

                      backgroundColor:
                          _isExpanded
                              ? const Color.fromARGB(255, 90, 182, 93)
                              : Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      Icons.close,
                      color: _isExpanded ? Colors.white : Colors.grey[600],
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  title: Text(
                    "Time Estimations",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey[600]!, width: 1),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Prep Time (minutes)",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Flexible(
                                      child: TextField(
                                        controller: widget.controllerPrepTime,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          constraints: BoxConstraints(
                                            maxWidth: 55.w,
                                            maxHeight: 40.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Cook Time (minutes)",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Flexible(
                                      child: TextField(
                                        controller: widget.controllerCookTime,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          constraints: BoxConstraints(
                                            maxWidth: 55.w,
                                            maxHeight: 40.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
            : Center(
              child: Column(
                children: [
                  Text(
                    widget.includeSectionText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 25,
                        onPressed: widget.onHide,
                        icon: Icon(Icons.close, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          minimumSize: Size(40.h, 40.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: widget.onModify,
                        iconSize: 25,
                        icon: Icon(Icons.check, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(40.h, 40.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        : SizedBox();
  }
}
