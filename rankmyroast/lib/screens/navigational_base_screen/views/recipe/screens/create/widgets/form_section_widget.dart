import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/create/widgets/widgets/item_list_view_widget.dart';

class FormSectionWidget extends StatelessWidget {
  final String header;
  final String subtitle;
  final String includeSectionText;
  final bool isNumericalList;
  final bool includeSection;
  final bool isHidden;
  final VoidCallback onModify;
  final VoidCallback onHide;
  final TextEditingController controller;
  final List<String> itemsList;
  final void Function(void Function()) setParentState;
  final void Function(String item) deleteFromParent;
  final void Function(int oldIndex, int newIndex) updatePositionForParentList;

  const FormSectionWidget({
    super.key,
    required this.header,
    required this.subtitle,
    required this.includeSectionText,
    required this.isNumericalList,
    required this.includeSection,
    required this.isHidden,
    required this.onModify,
    required this.onHide,
    required this.deleteFromParent,
    required this.controller,
    required this.itemsList,
    required this.setParentState,
    required this.updatePositionForParentList,
  });

  @override
  Widget build(BuildContext context) {
    return !isHidden
        ? includeSection
            ? Column(
              children: [
                ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 8.w),
                  backgroundColor: Colors.white,

                  initiallyExpanded: true,
                  shape: RoundedRectangleBorder(
                    side:
                        itemsList.isNotEmpty
                            ? BorderSide(color: Colors.grey[600]!)
                            : BorderSide(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: IconButton(
                    onPressed: onModify,
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,

                      backgroundColor: const Color.fromARGB(22, 161, 161, 161),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    padding: EdgeInsets.zero,
                  ),
                  title: Text(
                    header,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  children: [
                    ItemListViewWidget(
                      items: itemsList,
                      isNumericalList: isNumericalList,
                      deleteForParentList: deleteFromParent,
                      updatePositionForParentList: updatePositionForParentList,
                      setParentState: setParentState,
                    ),
                  ],
                ),

                SizedBox(height: 8),

                Container(
                  height: 42.h,
                  alignment: Alignment.center,

                  child: Row(
                    children: [
                      Expanded(
                        flex: 17,
                        child: Container(
                          height: 42.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[600]!),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: controller,

                            decoration: InputDecoration(
                              labelText: subtitle,
                              labelStyle: TextStyle(fontSize: 18),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,

                              isCollapsed: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: IconButton(
                          padding: EdgeInsets.zero,

                          onPressed: () {
                            if (controller.text.isEmpty) return;
                            setParentState(() {
                              itemsList.add(controller.text.trim());
                              controller.text = "";
                            });
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                          style: IconButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 42.h),

                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
            : Center(
              child: Column(
                children: [
                  Text(
                    includeSectionText,
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
                        onPressed: onHide,

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
                        onPressed: onModify,

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
