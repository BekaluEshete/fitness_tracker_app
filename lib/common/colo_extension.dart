import 'package:flutter/material.dart';

class TColor {
  static Color get primaryColor1 => const Color.fromARGB(255, 60, 224, 10);
  static Color get primaryColor2 => const Color.fromARGB(255, 21, 179, 76);

  static Color get secondaryColor1 => const Color.fromARGB(255, 3, 179, 120);
  static Color get secondaryColor2 => const Color.fromARGB(255, 164, 238, 221);

  static List<Color> get primaryG => [primaryColor2, primaryColor1];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);
}
