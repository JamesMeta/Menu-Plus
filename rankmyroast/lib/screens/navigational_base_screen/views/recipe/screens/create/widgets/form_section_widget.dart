import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/create/widgets/item_list_view_widget.dart';

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
    required this.controller,
    required this.itemsList,
    required this.setParentState,
  });

  @override
  Widget build(BuildContext context) {
    return !isHidden
        ? includeSection
            ? Column(
              children: [
                ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 8.w),
                  initiallyExpanded: true,
                  shape: RoundedRectangleBorder(
                    side:
                        itemsList.isNotEmpty
                            ? BorderSide(color: Colors.black)
                            : BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  leading: IconButton(
                    onPressed: onModify,
                    icon: Icon(Icons.close),
                    padding: EdgeInsets.zero,
                  ),
                  title: Text(
                    header,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  children: [
                    ItemListViewWidget(
                      items: itemsList,
                      isNumericalList: isNumericalList,
                      deleteForParentList:
                          (String item) => itemsList.remove(item),
                      updatePositionForParentList: (
                        int oldIndex,
                        int newIndex,
                      ) {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = itemsList.removeAt(oldIndex);
                        itemsList.insert(newIndex, item);
                      },
                      setParentState: setParentState,
                    ),
                  ],
                ),

                if (itemsList.isNotEmpty) SizedBox(height: 8),

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
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
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
                              side: BorderSide(color: Colors.black, width: 1),
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
                          backgroundColor: const Color.fromARGB(
                            255,
                            150,
                            150,
                            150,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onModify,
                        iconSize: 25,
                        icon: Icon(Icons.check, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green,
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
