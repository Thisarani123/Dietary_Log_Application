import 'package:dietary_log_app/AddMeal.dart';
import 'package:dietary_log_app/HomePage.dart';
import 'package:dietary_log_app/profile_setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

var indexClicked = 0;

class sidebar extends StatefulWidget {
  final String profileImageUrl;
  final String username;
  final String email;

  const sidebar({
    required this.profileImageUrl,
    required this.username,
    required this.email,
  });

  @override
  _sidebarState createState() => _sidebarState();
}

class _sidebarState extends State<sidebar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final pages = [
    DietaryLogPage(),
    AddMealScreen(
      onSave: (String mealType, int calories, double carbs, double protein,
          double fat) {},
    ),
    profilesetting(),
  ];

  Function updateState(int index) {
    return () {
      setState(() {
        indexClicked = index;
      });
      Navigator.pop(context);
    };
  }

  // Logout function to clear session and navigate to login page
  Future<void> logout(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear shared preferences (if used for session storage)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to the login screen after logout
      Navigator.pushReplacementNamed(context, '/login');  // Ensure '/login' is the route for your login screen
    } catch (e) {
      print("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred during logout"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/image.jpg'),
                ),
              ),
              padding: EdgeInsets.all(0),
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      radius: 42,
                      backgroundImage: NetworkImage(widget.profileImageUrl),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.username,
                      style: GoogleFonts.sanchez(
                        fontSize: 18,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.email,
                      style: GoogleFonts.sanchez(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (int i = 0; i < Defaults.drawerItemText.length; i++)
                    AppDrawerTile(
                      index: i,
                      onTap: updateState(i),
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Add the Logout option in the Drawer
                  ListTile(
                    title: Text(
                      'Logout',
                      style: GoogleFonts.robotoSlab(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 30,
                      color: Colors.black,
                    ),
                    onTap: () {
                      logout(context); // Call the logout function when tapped
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: pages[indexClicked],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer(); 
        },
        child: Icon(Icons.menu),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.startTop, 
    );
  }
}

class AppDrawerTile extends StatelessWidget {
  const AppDrawerTile({
    Key? key,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: ListTile(
        selected: indexClicked == index,
        selectedTileColor: Defaults.drawerSelectedTileColor,
        leading: Icon(
          Defaults.drawerItemIcon[index],
          size: 30,
          color: indexClicked == index
              ? Defaults.drawerItemSelectedColor
              : Defaults.drawerItemColor,
        ),
        title: Text(
          Defaults.drawerItemText[index],
          style: GoogleFonts.robotoSlab(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: indexClicked == index
                ? Defaults.drawerItemSelectedColor
                : Defaults.drawerItemColor,
          ),
        ),
        onTap: () {
          onTap();
        },
      ),
    );
  }
}

class Defaults {
  static final Color drawerItemColor = Color.fromARGB(255, 3, 7, 9);
  static final Color? drawerItemSelectedColor =
      Color.fromARGB(255, 249, 249, 249);
  static final Color? drawerSelectedTileColor =
      Color.fromARGB(255, 16, 145, 54);

  static final drawerItemText = [
    'Home',
    'Add Meal',
    'Profile',
  ];

  static final drawerItemIcon = [
    Icons.home,
    Icons.add_box_rounded,
    Icons.person,
  ];
}
