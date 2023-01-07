import 'package:flutter/material.dart';

// import '../rehmat.dart';

class Palette {

  static ColorScheme of(BuildContext context) => Theme.of(context).colorScheme;

  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
  
}