import 'package:dietary_log_app/SigninPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietary_log_app/screens/reusable_widget.dart';
import 'package:dietary_log_app/screens/glassmorphism.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  void _createUserInFirestore(String email, String username, String password) {
    FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'username': username,
      'password': password,
    }).then((value) {
      print("User added to Firestore with ID: ${value.id}");
    }).catchError((error) {
      print("Failed to add user to Firestore: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClippath(),
            child: Container(
              height: 300,
              color: const Color.fromARGB(255, 53, 53, 53),
              child: Center(
                child: Image.asset(
                  "assets/images/3757211.webp",
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Glassmorphism(
                blur: 1,
                opacity: 0.4,
                radius: 20,
                child: Container(
                  height: 430,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    children: [
                      buildInputField("E-MAIL:", "Enter Email", Icons.email,
                          false, _emailTextController),
                      buildInputField("USERNAME:", "Enter Username",
                          Icons.person, false, _usernameTextController),
                      buildInputField("PASSWORD:", "Enter Password", Icons.lock,
                          true, _passwordTextController),
                      SizedBox(height: 1),
                      signInSignUpButton(context, false, () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) {
                          _createUserInFirestore(
                              _emailTextController.text,
                              _usernameTextController.text,
                              _passwordTextController.text);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signinpage()));
                        }).onError((error, stackTrace) {
                          print("Error: ${error.toString()}");
                        });
                      }),
                      SizedBox(height: 1),
                      signOption(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildInputField(String label, String hint, IconData icon,
      bool isPassword, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 1),
        reusableTextField(hint, icon, isPassword, controller),
        SizedBox(height: 8),
      ],
    );
  }
  Row signOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("ALREADY HAVE AN ACCOUNT?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Signinpage()));
          },
          child: const Text(
            "LOGIN HERE",
            style: TextStyle(
                color: Color.fromARGB(255, 196, 10, 47),
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
class CustomClippath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;

    final path = Path();
    path.lineTo(0, h - 50);
    path.quadraticBezierTo(w / 2, h + 50, w, h - 50);
    path.lineTo(w, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
