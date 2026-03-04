import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/calendar/calendar_view.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/groups_view.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/home/home_view.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/recipe/recipe_view.dart';
import 'package:rankmyroast/screens/navigational_base_screen/widgets/create_username_dialog_widget.dart';
import 'package:rankmyroast/screens/navigational_base_screen/widgets/sign_out_dialog_widget.dart';
import 'package:rankmyroast/services/supabase_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NavigationalBaseScreen extends StatefulWidget {
  const NavigationalBaseScreen({super.key});

  @override
  State<NavigationalBaseScreen> createState() => _NavigationalBaseScreenState();
}

class _NavigationalBaseScreenState extends State<NavigationalBaseScreen> {
  int navigationalIndex = 1;

  final List<BottomNavigationBarItem> _bottomNavigationalItems = [
    BottomNavigationBarItem(
      label: "Group",
      icon: Icon(Icons.group, color: Colors.white),
    ),
    BottomNavigationBarItem(
      label: "Home",
      icon: Icon(Icons.home, color: Colors.white),
    ),
    BottomNavigationBarItem(
      label: "Calendar",
      icon: Icon(Icons.calendar_month, color: Colors.white),
    ),
    BottomNavigationBarItem(
      label: "Recipe",
      icon: Icon(Icons.restaurant, color: Colors.white),
    ),
  ];

  final List<Widget> navigationalViews = [
    GroupsView(),
    HomeView(),
    CalendarView(),
    RecipeView(),
  ];

  @override
  void initState() {
    _handleUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: _goToSettings,
            icon: Icon(Icons.settings, color: Colors.white),
          ),
          IconButton(
            onPressed:
                () => showDialog(
                  context: context,
                  builder: (BuildContext context) => SignOutDialogWidget(),
                ),
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: navigationalViews[navigationalIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: const Color.fromARGB(255, 97, 223, 101),
        iconSize: 32,

        onTap: (value) {
          setState(() {
            navigationalIndex = value;
          });
        },
        currentIndex: navigationalIndex,
        items: _bottomNavigationalItems,
      ),
    );
  }

  void _goToSettings() {
    context.push("/settings");
  }

  Future<void> _handleUsername() async {
    final hasUsername = await SupabaseHelper.checkForUsername();

    if (hasUsername) {
      return;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => CreateUsernameDialogWidget(),
      );
    }
  }
}
