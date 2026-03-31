import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rankmyroast/models/group.dart';

class AddToGroupsDialogWidget extends StatefulWidget {
  final List<Group> groups;
  final List<Group>? selectedGroups;

  const AddToGroupsDialogWidget({
    super.key,
    required this.groups,
    this.selectedGroups,
  });

  @override
  State<AddToGroupsDialogWidget> createState() =>
      _AddToGroupsDialogWidgetState();
}

class _AddToGroupsDialogWidgetState extends State<AddToGroupsDialogWidget> {
  final List<Group> _selectedGroups = [];

  @override
  void initState() {
    if (widget.selectedGroups != null) {
      _selectedGroups.addAll(
        widget.groups.where(
          (groupWidget) => widget.selectedGroups!.contains(groupWidget),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Groups for Recipe"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children:
                    widget.groups
                        .map(
                          (group) => ListTile(
                            leading: Checkbox(
                              value: _selectedGroups.contains(group),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGroups.contains(group)
                                      ? _selectedGroups.remove(group)
                                      : _selectedGroups.add(group);
                                });
                              },
                            ),
                            title: Text(group.name),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: () => context.pop(), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () => context.pop(_selectedGroups),
          child: Text("Apply"),
        ),
      ],
    );
  }
}
