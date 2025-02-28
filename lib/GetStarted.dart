import 'package:dietary_log_app/SigninPage.dart';
import 'package:dietary_log_app/SignupPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}
class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 140, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("assets/images/getstarted.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              key: const Key('splash_rich_text'),
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Health",
                      style: GoogleFonts.pacifico(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "Bites",
                      style: GoogleFonts.pacifico(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 3, 248, 3), 
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Lose weight, get healthy, change your habits or start a new diet plan.",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 80),
                  InkWell(
                    key: const Key('get_started_button'),
                    splashColor: Colors.black,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Signinpage()));
                    },
                    child: Ink(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(213, 6, 252, 43),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
