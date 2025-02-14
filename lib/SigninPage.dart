import 'package:dietary_log_app/SignupPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dietary_log_app/screens/glassmorphism.dart';
import 'package:dietary_log_app/screens/reusable_widget.dart';
import 'package:dietary_log_app/sidebar.dart';

class Signinpage extends StatefulWidget {
  const Signinpage({super.key});

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: CustomClippath(),
            child: Container(
              height: 350,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Glassmorphism(
                blur: 1,
                opacity: 0.4,
                radius: 20,
                child: Container(
                  height: 350,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    children: [
                      buildInputField("E-MAIL:", "Enter Email", Icons.email,
                          false, _emailTextController),
                      buildInputField("PASSWORD:", "Enter Password", Icons.lock,
                          true, _passwordTextController),
                      SizedBox(height: 1),
                      signInSignUpButton(context, true, () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => sidebar(
                                        profileImageUrl: '',
                                        username: '',
                                        email: '',
                                      )));
                        }).onError((error, stackTrace) {
                          print("Error: ${error.toString()}");
                        });
                      }),
                      SizedBox(height: 1),
                      signUpOption(),
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
  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("NO ACCOUNT?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "SIGN UP HERE",
            style: TextStyle(
                color: Color.fromARGB(255, 176, 6, 40),
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
