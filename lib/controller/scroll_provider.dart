import 'package:flutter/material.dart';

class ScrollProvider extends ChangeNotifier {
  bool canScroll = true;
  void changeScroll(bool value) {
    canScroll = value;
    notifyListeners();
  }
}
