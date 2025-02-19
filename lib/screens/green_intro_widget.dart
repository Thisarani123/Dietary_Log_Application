import 'package:flutter/material.dart';

Widget greenIntroWidgetWithoutLogos() {
  return Container(
    width: 435,
    decoration: BoxDecoration(
        gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 194, 249, 200),
        Color.fromARGB(255, 226, 248, 231),
        Color.fromARGB(255, 169, 238, 182),
        Color.fromARGB(197, 120, 220, 145),
      ],
      begin: Alignment.topRight,
      end: Alignment.bottomCenter,
    )),
    height: 140,
    child: Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )),
  );
}