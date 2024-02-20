import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  int index = 0;

  onPageChanged(index) {
    this.index = index;
    notifyListeners();
  }
}
