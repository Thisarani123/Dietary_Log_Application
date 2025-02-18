import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class profilesetting extends StatefulWidget {
  const profilesetting({super.key});

  @override
  State<profilesetting> createState() => _profilesettingState();
}

class _profilesettingState extends State<profilesetting> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 102, 26),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 23, vertical: 23),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFieldWidget('User Name', Icons.person, nameController,
                        (String? input) {}),
                    const SizedBox(
                      height: 22,
                    ),
                    TextFieldWidget('Email ID', Icons.email_rounded,
                        emailController, (String? input) {}),
                    const SizedBox(
                      height: 22,
                    ),
                    TextFieldWidget('Phone Number', Icons.phone,
                        phonenumberController, (String? input) {}),
                    const SizedBox(
                      height: 22,
                    ),
                    TextFieldWidget('Password', Icons.lock, passwordController,
                        (String? input) {}),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

TextFieldWidget(String title, IconData iconData,
    TextEditingController controller, Function validator) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      const SizedBox(
        height: 6,
      ),
      Container(
        width: 350,
        height: 55,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 251, 251, 249),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 1)
            ],
            borderRadius: BorderRadius.circular(8)),
      )
    ],
  );
}
