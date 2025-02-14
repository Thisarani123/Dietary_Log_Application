import 'package:dietary_log_app/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  ];
  Function updateState(int index) {
    return () {
      setState(() {
        indexClicked = index;
      });
      Navigator.pop(context);
    };
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
                  image: AssetImage('assets/images/girl.webp'),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
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
      Color.fromARGB(255, 149, 222, 171);

  static final drawerItemText = [
    'Home',
  ];

  static final drawerItemIcon = [
    Icons.home,
  ];
}
