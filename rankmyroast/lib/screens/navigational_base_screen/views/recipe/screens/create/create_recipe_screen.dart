import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rankmyroast/common_widgets/take_photo_bottom_modal_widget.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/recipe.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/create/widgets/add_to_groups_dialog_widget.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/create/widgets/item_list_view_widget.dart';
import 'package:rankmyroast/services/supabase_helper.dart';

class CreateRecipeScreen extends StatefulWidget {
  final Recipe? recipeToEdit;
  final Group? selectedGroup;
  final List<Group> groups;

  const CreateRecipeScreen({
    super.key,
    this.recipeToEdit,
    this.selectedGroup,
    required this.groups,
  });

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  late final String _labelText;

  File? _recipeImage;

  bool _isPublic = false;
  bool _isCreatingRecipe = false;
  bool _canSubmit = false;
  bool _includeIngredients = false;
  bool _includeInstructions = false;
  bool _includeGroceryItems = false;
  bool _includeGroups = false;
  bool _hideIngredients = false;
  bool _hideInstructions = false;
  bool _hideGroceryItems = false;
  bool _hideGroups = false;

  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _groceryItemsController = TextEditingController();
  final TextEditingController _groupsController = TextEditingController();

  final List<String> _ingredientsList = [];
  final List<String> _instructionsList = [];
  final List<String> _groceryList = [];

  List<Group> _selectedGroups = [];

  @override
  void initState() {
    widget.recipeToEdit == null
        ? _labelText = "Create Recipe"
        : _labelText = "Edit Recipe";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,

        foregroundColor: Colors.white,
        title: Text(
          _labelText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (widget.recipeToEdit != null)
            IconButton(
              onPressed: () async {},
              icon: Icon(Icons.delete, color: Colors.white),
            ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),

            onSelected: (String result) {
              if (result == 'Option 1') {
                _showHiddenFields();
              }
            },

            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Option 1',
                    child: Text('Show Hidden Items'),
                  ),
                ],
          ),
        ],
      ),
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 128.w,
                            height: 128.w,
                            child:
                                _recipeImage == null
                                    ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.camera_alt, size: 48),
                                        onPressed:
                                            () async =>
                                                await _updateRecipeImage(),
                                      ),
                                    )
                                    : GestureDetector(
                                      onTap:
                                          () async =>
                                              await _updateRecipeImage(),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(32),
                                        child: Image.file(
                                          _recipeImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Container(
                                    height: 42.h,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: "Recipe Name",
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      if (_ingredientsList.isNotEmpty) SizedBox(height: 8),

                      _buildFormSection(
                        header: "Ingredients",
                        subtitle: "Add ingredients...",
                        isNumericalList: false,
                        controller: _ingredientsController,
                        itemsList: _ingredientsList,
                        includeSection: _includeIngredients,
                        includeSectionText: "Include Ingredients?",
                        onModify:
                            () => setState(() {
                              _includeIngredients = !_includeIngredients;
                            }),
                        isHidden: _hideIngredients,
                        onHide:
                            () => setState(() {
                              _hideIngredients = true;
                            }),
                      ),

                      SizedBox(height: 16),

                      _buildFormSection(
                        header: "Instructions",
                        subtitle: "Add instructions...",
                        isNumericalList: true,
                        controller: _instructionsController,
                        itemsList: _instructionsList,
                        includeSection: _includeInstructions,
                        includeSectionText: "Include Instructions?",
                        onModify:
                            () => setState(() {
                              _includeInstructions = !_includeInstructions;
                            }),
                        isHidden: _hideInstructions,
                        onHide:
                            () => setState(() {
                              _hideInstructions = true;
                            }),
                      ),

                      SizedBox(height: 16),

                      _buildFormSection(
                        header: "Grocery Items",
                        subtitle: "Add items to purchase...",
                        isNumericalList: false,
                        controller: _groceryItemsController,
                        itemsList: _groceryList,
                        includeSection: _includeGroceryItems,
                        includeSectionText: "Include Grocery Items?",
                        onModify:
                            () => setState(() {
                              _includeGroceryItems = !_includeGroceryItems;
                            }),
                        isHidden: _hideGroceryItems,
                        onHide:
                            () => setState(() {
                              _hideGroceryItems = true;
                            }),
                      ),

                      SizedBox(height: 16),

                      _buildGroupsFormSection(),

                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: _isPublic,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           _isPublic = !_isPublic;
                      //         });
                      //       },
                      //       semanticLabel: "Make Recipe Public",
                      //     ),
                      //     Text("Make Recipe Public"),
                      //   ],
                      // ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_isCreatingRecipe) return;
                          if (!_canSubmit) return;
                          setState(() {
                            _isCreatingRecipe = true;
                          });

                          late final bool? response;
                          if (widget.recipeToEdit != null) {
                            //TODO
                            response = true;
                          } else {
                            //TODO
                          }
                          setState(() {
                            _isCreatingRecipe = false;
                          });

                          if (response == true && context.mounted) {
                            context.pop(true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _canSubmit ? Colors.green : Colors.grey,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          maximumSize: Size(double.infinity, 50.h),
                          minimumSize: Size(double.infinity, 50.h),
                          shadowColor: Colors.black,
                        ),
                        child:
                            _isCreatingRecipe
                                ? CircularProgressIndicator()
                                : Text(
                                  _labelText,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupsFormSection() {
    return !_hideGroups
        ? _includeGroups
            ? Column(
              children: [
                ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 8.w),
                  initiallyExpanded: true,
                  shape: Border.all(color: Colors.transparent),
                  leading: IconButton(
                    onPressed:
                        () => setState(() {
                          _includeGroups = false;
                        }),
                    icon: Icon(Icons.close),
                    padding: EdgeInsets.zero,
                  ),

                  title: Text(
                    "Add to Groups",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 150.h),
                      child: ItemListViewWidget(
                        items:
                            _selectedGroups.map((group) => group.name).toList(),
                        isNumericalList: false,
                        deleteForParentList:
                            (String item) => _selectedGroups.removeWhere(
                              (group) => group.name == item,
                            ),
                        updatePositionForParentList:
                            (int oldIndex, int newIndex) {},
                      ),
                    ),
                  ],
                ),

                if (_selectedGroups.isNotEmpty) SizedBox(height: 8),

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
                          child: GestureDetector(
                            onTap: () async {
                              final List<Group>? result = await showDialog(
                                context: context,
                                builder:
                                    (context) => AddToGroupsDialogWidget(
                                      groups: widget.groups,
                                      selectedGroups: _selectedGroups,
                                    ),
                              );

                              if (result != null) {
                                _groupsController.text = result
                                    .map((group) => group.name)
                                    .join(", ");
                              }
                            },
                            child: TextField(
                              controller: _groupsController,

                              decoration: InputDecoration(
                                labelText: "Click to add groups...",
                                labelStyle: TextStyle(fontSize: 18),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,

                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                border: InputBorder.none,
                                enabled: false,
                              ),
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
                            if (_groupsController.text.isEmpty) return;
                            final groupNames = _groupsController.text.split(
                              ", ",
                            );
                            setState(() {
                              _selectedGroups.addAll(
                                widget.groups.where(
                                  (group) => groupNames.contains(group.name),
                                ),
                              );
                              _groupsController.text = "";
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
                    "Add to your Groups?",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 40.w,
                          maxWidth: 40.w,
                        ),
                        padding: EdgeInsets.all(1),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 150, 150, 150),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 25,
                          onPressed:
                              () => setState(() {
                                _hideGroups = true;
                              }),
                          icon: Icon(
                            Icons.close,
                            color: const Color.fromARGB(255, 150, 150, 150),
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 40.w,
                          maxWidth: 40.w,
                        ),
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed:
                              () => setState(() {
                                _includeGroups = true;
                              }),
                          iconSize: 25,
                          icon: Icon(Icons.check, color: Colors.green),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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

  Widget _buildFormSection({
    required String header,
    required String subtitle,
    required bool isNumericalList,
    required TextEditingController controller,
    required List<String> itemsList,
    required bool includeSection,
    required VoidCallback onModify,
    required bool isHidden,
    required VoidCallback onHide,
    required String includeSectionText,
  }) {
    return !isHidden
        ? includeSection
            ? Column(
              children: [
                ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 8.w),
                  initiallyExpanded: true,
                  shape: Border.all(color: Colors.transparent),
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
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 800.h),
                      child: ItemListViewWidget(
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
                      ),
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
                            setState(() {
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
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 40.w,
                          maxWidth: 40.w,
                        ),
                        padding: EdgeInsets.all(1),
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 150, 150, 150),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 25,
                          onPressed: onHide,
                          icon: Icon(
                            Icons.close,
                            color: const Color.fromARGB(255, 150, 150, 150),
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 40.w,
                          maxWidth: 40.w,
                        ),
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: onModify,
                          iconSize: 25,
                          icon: Icon(Icons.check, color: Colors.green),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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

  Future<File?> _updateRecipeImage() async {
    File? file = await showModalBottomSheet(
      context: context,
      builder: (context) => TakePhotoBottomModalWidget(),
    );

    if (file != null) {
      setState(() {
        _recipeImage = file;
      });
    }
  }

  //TODO
  // MAKE THIS WORK AS INTENDED
  Future<String?> _handleImageUploadProcedure(File file) async {
    String folderName = SupabaseHelper.users.getAuthId();

    final String fileName = DateTime.now().toString();

    try {
      final path = await SupabaseHelper.storage.uploadFileToFolder(
        bucketName: "recipe_image",
        folderName: folderName,
        file: file,
        fileName: fileName,
      );

      return path;
    } on Exception catch (e) {
      print("Something went wrong when uploading file");
    }
  }

  void _showHiddenFields() {
    setState(() {
      _hideGroceryItems = false;
      _hideGroups = false;
      _hideIngredients = false;
      _hideInstructions = false;
    });
  }

  @override
  void dispose() {
    _groceryItemsController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _recipeNameController.dispose();
    _groupsController.dispose();
    super.dispose();
  }
}
