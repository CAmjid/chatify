import 'package:flutter/foundation.dart';

class Controller extends ChangeNotifier {
  int selectedindex = 0;

  void changeData(int index) {
    selectedindex = index;
    notifyListeners();
  }
}
