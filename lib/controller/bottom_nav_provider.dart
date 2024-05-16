import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int currentIndex = 0;
  void setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
