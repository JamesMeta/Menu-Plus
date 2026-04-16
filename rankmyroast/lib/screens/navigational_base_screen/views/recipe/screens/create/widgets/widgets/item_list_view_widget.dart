import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemListViewWidget extends StatefulWidget {
  final List<String> items;
  final bool isNumericalList;
  final Function(String item) deleteForParentList;
  final Function(int oldIndex, int newIndex) updatePositionForParentList;
  final void Function(void Function()) setParentState;

  const ItemListViewWidget({
    super.key,
    required this.items,
    required this.isNumericalList,
    required this.deleteForParentList,
    required this.updatePositionForParentList,
    required this.setParentState,
  });

  @override
  State<ItemListViewWidget> createState() => _ItemListViewWidgetState();
}

class _ItemListViewWidgetState extends State<ItemListViewWidget> {
  late List<String> _itemsList;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _itemsList = widget.items.toList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemListViewWidget oldWidget) {
    if (oldWidget.items != widget.items || widget.items != _itemsList) {
      setState(() {
        _itemsList = widget.items.toList();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  void _deleteItem(String item) {
    setState(() {
      _itemsList.remove(item);
    });

    if (_itemsList.isEmpty) {
      widget.setParentState(() => widget.deleteForParentList(item));
    } else {
      widget.deleteForParentList(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _itemsList.isNotEmpty
        ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(color: Colors.grey[600]!),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 800.h, minHeight: 100.h),
              child: ReorderableListView.builder(
                scrollController: _scrollController,
                onReorder: (oldIndex, newIndex) {
                  widget.updatePositionForParentList(oldIndex, newIndex);
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _itemsList.removeAt(oldIndex);
                    _itemsList.insert(newIndex, item);
                  });
                },

                shrinkWrap: true,

                itemCount: _itemsList.length,
                clipBehavior: Clip.none,
                itemBuilder: (context, index) {
                  return Container(
                    key: Key('$index'),
                    margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: const Color.fromARGB(124, 149, 161, 150),
                        ),
                      ),
                      leading: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.drag_handle, color: Colors.grey[600]),
                      ),

                      title: Text(
                        widget.isNumericalList
                            ? "${index + 1}. ${_itemsList[index]}"
                            : _itemsList[index],
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: IconButton(
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: const Color.fromARGB(
                            43,
                            255,
                            82,
                            82,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _deleteItem(_itemsList[index]),
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
        : SizedBox();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
