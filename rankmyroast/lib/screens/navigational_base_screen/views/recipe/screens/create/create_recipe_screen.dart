import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rankmyroast/common_widgets/take_photo_bottom_modal_widget.dart';
import 'package:rankmyroast/models/responses/create_recipe_response.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/recipe.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/create/widgets/widgets/add_to_groups_dialog_widget.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/create/widgets/form_section_widget.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/create/widgets/group_form_section_widget.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/screens/create/widgets/widgets/item_list_view_widget.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final List<Group> _selectedGroups = [];

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
                                      controller: _recipeNameController,
                                      onChanged:
                                          (value) =>
                                              _recipeNameController
                                                      .text
                                                      .isNotEmpty
                                                  ? setState(() {
                                                    _canSubmit = true;
                                                  })
                                                  : setState(() {
                                                    _canSubmit = false;
                                                  }),
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

                      FormSectionWidget(
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
                        setParentState: setState,
                        deleteFromParent:
                            (item) => _ingredientsList.remove(item),
                      ),

                      SizedBox(height: 16),

                      FormSectionWidget(
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
                        setParentState: setState,
                        deleteFromParent:
                            (item) => _instructionsList.remove(item),
                      ),

                      SizedBox(height: 16),

                      FormSectionWidget(
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
                        setParentState: setState,
                        deleteFromParent: (item) => _groceryList.remove(item),
                      ),

                      SizedBox(height: 16),

                      GroupFormSectionWidget(
                        header: "Add to Groups",
                        subtitle: "Click to add groups...",
                        includeSectionText: "Add to your Groups?",
                        isNumericalList: false,
                        includeSection: _includeGroups,
                        isHidden: _hideGroups,
                        onModify:
                            () => setState(() {
                              _includeGroups = !_includeGroups;
                            }),
                        onHide:
                            () => setState(() {
                              _hideGroups = true;
                            }),
                        controller: _groupsController,
                        itemsList: _selectedGroups,
                        groups: widget.groups,
                        setParentState: setState,
                        deleteFromParent:
                            (item) => _selectedGroups.removeWhere(
                              (group) => group.name == item,
                            ),
                      ),

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
                            response = await _createRecipe();
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

  Future<bool> _createRecipe() async {
    if (_recipeNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Recipe name cannot be empty")));
      return false;
    }

    final name = _recipeNameController.text.trim();

    final response = await SupabaseHelper.recipe.createNewRecipe(
      _recipeImage,
      name,
      _ingredientsList,
      _instructionsList,
      _groceryList,
      _selectedGroups,
      _isPublic,
    );

    if (response.success && mounted) {
      final failedGroups = response.failedToAddGroups;
      final failedImage = response.failedToUploadImage;

      if (failedGroups != null) {
        if (failedGroups.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add recipe to groups.")),
          );
        }
      }

      if (failedImage != null) {
        if (failedImage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to upload image for recipe")),
          );
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Recipe Created Successfully")));
      return true;
    } else if (!response.success && mounted) {
      final localError = response.localError;
      final errorMessage = response.errorMessage;

      if (localError != null && errorMessage != null) {
        if (localError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      }
    }

    return false;
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
    return null;
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
