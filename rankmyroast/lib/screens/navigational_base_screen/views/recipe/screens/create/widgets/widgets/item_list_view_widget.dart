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
            Divider(color: Colors.black),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 800.h, minHeight: 100.h),
              child: ReorderableListView.builder(
                scrollController: _scrollController,
                onReorder: (oldIndex, newIndex) {
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
                  return ListTile(
                    key: Key('$index'),
                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: Icon(Icons.drag_handle),
                    ),
                    title: Text(
                      widget.isNumericalList
                          ? "${index + 1}. ${_itemsList[index]}"
                          : _itemsList[index],
                    ),
                    trailing: IconButton(
                      onPressed: () => _deleteItem(_itemsList[index]),
                      icon: Icon(Icons.delete),
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
