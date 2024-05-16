import 'package:flutter/material.dart';

import 'text_theme.dart';

class GlobalThemeData {
  static ThemeData get defaultTheme => ThemeData(
        primarySwatch: const MaterialColor(0x000296E5, <int, Color>{
          50: Color(0xFF80BFFF),
          100: Color(0xFF4D9EFF),
          200: Color(0xFF268BFF),
          300: Color(0xFF0077FF),
          400: Color(0xFF005CFF),
          500: Color(0xFF2196F3),
          600: Color(0xFF0072C1),
          700: Color(0xFF004B91),
          800: Color(0xFF00396E),
          900: Color(0xFF00284A),
        }),
        primaryColor: const Color.fromARGB(255, 2, 150, 229),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 36, 42, 50),
        dividerColor: Colors.white54,
        fontFamily: 'Poppins',
        textTheme: GlobalTextTheme.textTheme,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 36, 42, 50),
            selectedItemColor: Color.fromARGB(255, 2, 150, 229),
            unselectedItemColor: Color.fromARGB(255, 103, 104, 109),
            elevation: 0),
        unselectedWidgetColor: const Color.fromARGB(255, 103, 104, 109),
      );
}
