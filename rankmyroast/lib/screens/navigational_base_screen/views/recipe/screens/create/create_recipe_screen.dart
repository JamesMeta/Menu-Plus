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

  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _groceryItemsController = TextEditingController();

  final List<String> _ingredientsList = [];
  final List<String> _instructionsList = [];
  final List<String> _groceryList = [];

  List<Group> _selectedGroups = [];
  Group? _selectedGroup;

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

                      ExpansionTile(
                        title: Text(
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 150.h),
                            child: ItemListViewWidget(
                              items: _ingredientsList,
                              deleteForParentList:
                                  (String item) =>
                                      _ingredientsList.remove(item),
                              updatePositionForParentList: (
                                int oldIndex,
                                int newIndex,
                              ) {
                                if (newIndex > oldIndex) newIndex -= 1;
                                final item = _ingredientsList.removeAt(
                                  oldIndex,
                                );
                                _ingredientsList.insert(newIndex, item);
                              },
                            ),
                          ),
                        ],
                      ),

                      if (_ingredientsList.isNotEmpty) SizedBox(height: 8),

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
                                  controller: _ingredientsController,

                                  decoration: InputDecoration(
                                    labelText: "Add ingredients...",
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
                                  if (_ingredientsController.text.isEmpty)
                                    return;
                                  setState(() {
                                    _ingredientsList.add(
                                      _ingredientsController.text.trim(),
                                    );
                                    _ingredientsController.text = "";
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
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        "Instructions",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

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
                                  controller: _instructionsController,

                                  decoration: InputDecoration(
                                    labelText: "Add instructions...",
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

                                onPressed: () {},
                                icon: Icon(Icons.add, color: Colors.white),
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 42.h),

                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        "Grocery Items",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

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
                                  controller: _groceryItemsController,

                                  decoration: InputDecoration(
                                    labelText: "Add items to purchase...",
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

                                onPressed: () {},
                                icon: Icon(Icons.add, color: Colors.white),
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(0, 42.h),

                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    side: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        "Add to Groups",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      GestureDetector(
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
                            setState(() {
                              _selectedGroups = result;
                            });
                          }
                        },
                        child: Container(
                          height: 42.h,
                          alignment:
                              _selectedGroups.isEmpty
                                  ? Alignment.center
                                  : Alignment.centerLeft,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              _selectedGroups.isEmpty
                                  ? Text(
                                    "Click to Add Groups...",
                                    style: TextStyle(fontSize: 18),
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.all(8.0),

                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children:
                                          _selectedGroups
                                              .map(
                                                (group) => Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 1,
                                                      ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            171,
                                                            233,
                                                            173,
                                                          ),
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Text(
                                                        group.name,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ),
                        ),
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: _isPublic,
                            onChanged: (value) {
                              setState(() {
                                _isPublic = !_isPublic;
                              });
                            },
                            semanticLabel: "Make Recipe Public",
                          ),
                          Text("Make Recipe Public"),
                        ],
                      ),

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

  Future<String?> _handleImageUploadProcedure(File file) async {
    String folderName = SupabaseHelper.users.getAuthId();

    if (_selectedGroup != null) {
      folderName = _selectedGroup!.name;
    }

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

  @override
  void dispose() {
    _groceryItemsController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}
