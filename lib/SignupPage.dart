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
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? emailError;
  String? usernameError;
  String? passwordError;
  bool _isLoading = false;

  void _signUp() async {
    String email = _emailTextController.text.trim();
    String username = _usernameTextController.text.trim();
    String password = _passwordTextController.text.trim();

    setState(() {
      emailError = email.isEmpty ? "Email is required" : null;
      usernameError = username.isEmpty ? "Username is required" : null;
      passwordError = password.isEmpty
          ? "Password is required"
          : password.length < 8
              ? "Password must be at least 8 characters long"
              : null;
    });

    if (emailError != null || usernameError != null || passwordError != null) return;

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      setState(() {
        emailError = "Enter a valid email address";
      });
      return;
    }

    // Check if email is already taken in Firestore
    var existingUser = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (existingUser.docs.isNotEmpty) {
      setState(() {
        emailError = "Email already exists";
      });
      return;
    }

    var existingUsername = await _firestore.collection('users').where('username', isEqualTo: username).get();
    if (existingUsername.docs.isNotEmpty) {
      setState(() {
        usernameError = "Username already taken";
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();


      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'username': username,
      });

      _showError("Verification email sent. Please verify before logging in.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Signinpage()));
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Sign up failed!");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Glassmorphism(
                blur: 1,
                opacity: 0.4,
                radius: 20,
                child: Container(
                  height: 480,
                  width: double.infinity,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    children: [
                      buildInputField(
                        "E-MAIL:",
                        "Enter Email",
                        Icons.email,
                        false,
                        _emailTextController,
                        emailError,
                      ),
                      buildInputField(
                        "USERNAME:",
                        "Enter Username",
                        Icons.person,
                        false,
                        _usernameTextController,
                        usernameError,
                      ),
                      buildInputField(
                        "PASSWORD:",
                        "Enter Password",
                        Icons.lock,
                        true,
                        _passwordTextController,
                        passwordError,
                      ),
                      const SizedBox(height: 10),
                      _isLoading
                          ? CircularProgressIndicator()
                          : signInSignUpButton(context, false, _signUp),
                      const SizedBox(height: 10),
                      signInOption(),
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

  Widget buildInputField(String label, String hint, IconData icon, bool isPassword,
      TextEditingController controller, String? error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.black),
            filled: true,
            fillColor: Color.fromARGB(255, 82, 147, 90).withOpacity(0.9),
            errorText: error,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
              borderSide: BorderSide(
                  color: error != null ? Colors.red : Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(80),
              borderSide: BorderSide(
                  color: error != null ? Colors.red : Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Row signInOption() {
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
            "SIGN IN HERE",
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