import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color blueClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xffafa439);
const Color pinkClr = Color(0xffef2fe3);
const Color white = Colors.white;
const primaryClr = blueClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {

  static final light = ThemeData(
      backgroundColor: white,
      primaryColor: primaryClr,
      brightness: Brightness.light
  );

  static final dark = ThemeData(
      backgroundColor: darkGreyClr,
      primaryColor: darkGreyClr,
      brightness: Brightness.dark
  );

}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.grey[400]:Colors.grey
    )
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.grey[100]:Colors.grey[400]
      )
  );
}
