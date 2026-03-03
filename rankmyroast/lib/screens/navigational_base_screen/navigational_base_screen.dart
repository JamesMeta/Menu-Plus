import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/calendar/calendar_view.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/groups/groups_view.dart';
import 'package:rankmyroast/screens/navigational_base_screen/views/home/home_view.dart';
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
  ];

  final List<Widget> navigationalViews = [
    GroupsView(),
    HomeView(),
    CalendarView(),
  ];

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
            onPressed: _signOutDialog,
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: navigationalViews[navigationalIndex],
      bottomNavigationBar: BottomNavigationBar(
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

  void _signOutDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _signOut();
              },
              child: Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    await SupabaseHelper.authSignOut();
    context.go('/login');
  }

  void _goToSettings() {
    context.push("/settings");
  }
}
