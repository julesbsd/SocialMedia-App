import 'package:flutter/material.dart';

class Pageprovider with ChangeNotifier {
  int index = 1;

  void setIndex(int newIndex) {
    index = newIndex;
    notifyListeners();
  }

  int getIndex() {
    return index;
  }
}
