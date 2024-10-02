import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {

  static final light = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.deepPurpleAccent,
  brightness: Brightness.light,
  );

  static final dark = ThemeData(
    scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.deepPurpleAccent,
  brightness: Brightness.dark,
  );
}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode? Colors.grey[400]:Colors.grey
    )
  );
}
TextStyle get headingStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        color: Get.isDarkMode? Colors.white:Colors.black
      )
  );
}
TextStyle get titleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode? Colors.white:Colors.black
    )
  );
}
TextStyle get subTitleStyle{
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode? Colors.grey[100]:Colors.black
      )
  );
}
