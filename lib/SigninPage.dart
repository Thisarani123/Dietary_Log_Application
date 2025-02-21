import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? emailError;
  String? passwordError;
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _passwordVisible = false;

  void _signIn() async {
    String email = _emailTextController.text.trim();
    String password = _passwordTextController.text.trim();

    setState(() {
      emailError = email.isEmpty ? "Email is required" : null;
      passwordError = password.isEmpty
          ? "Password is required"
          : password.length < 8
              ? "Password must be at least 8 characters long"
              : null;
    });

    if (emailError != null || passwordError != null) return;

    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email)) {
      setState(() {
        emailError = "Enter a valid email address";
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String username = userDoc['username'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => sidebar(
            profileImageUrl: '',
            username: username,
            email: email,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Invalid email or password!");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _resetPassword() async {
    if (_emailTextController.text.isEmpty) {
      _showError("Enter your email to reset password.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: _emailTextController.text.trim());
      _showError("Password reset email sent.");
    } catch (e) {
      _showError("Error sending password reset email.");
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Glassmorphism(
                blur: 1,
                opacity: 0.4,
                radius: 20,
                child: Container(
                  height: 420,
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
                        "PASSWORD:",
                        "Enter Password",
                        Icons.lock,
                        !_passwordVisible,
                        _passwordTextController,
                        passwordError,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                              ),
                              const Text("Remember Me"),
                            ],
                          ),
                          TextButton(
                            onPressed: _resetPassword,
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : signInSignUpButton(context, true, _signIn),
                      const SizedBox(height: 10),
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

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("DON'T HAVE AN ACCOUNT?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpScreen()));
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
