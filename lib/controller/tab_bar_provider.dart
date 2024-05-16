import 'package:flutter/material.dart';

class TabBarProvider extends ChangeNotifier {
  int currentIndex = 0;
  void setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
