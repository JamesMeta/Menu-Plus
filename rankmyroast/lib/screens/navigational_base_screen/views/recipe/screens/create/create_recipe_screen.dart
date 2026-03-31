import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rankmyroast/models/group.dart';
import 'package:rankmyroast/models/recipe.dart';

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
  bool _isPublic = false;
  bool _isCreatingRecipe = false;
  bool _canSubmit = false;

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
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 128.w,
                          height: 128.w,
                          child: Placeholder(),
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

                    Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Container(
                      height: 42.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Add member by username",
                          labelStyle: TextStyle(fontSize: 18),
                          floatingLabelBehavior: FloatingLabelBehavior.never,

                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: InputBorder.none,
                        ),
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
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Add member by username",
                          labelStyle: TextStyle(fontSize: 18),
                          floatingLabelBehavior: FloatingLabelBehavior.never,

                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: InputBorder.none,
                        ),
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
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Add member by username",
                          labelStyle: TextStyle(fontSize: 18),
                          floatingLabelBehavior: FloatingLabelBehavior.never,

                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: InputBorder.none,
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
    );
  }
}
