import 'package:flutter/material.dart';
import 'package:moviely/resources/themes/themes.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeProvider get instance => ThemeProvider();
  ThemeData _themeData = GlobalThemeData.defaultTheme;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  ThemeData get themeData => _themeData;
}
