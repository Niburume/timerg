import 'package:flutter/material.dart';
import 'data_provider.dart';

class TimerProvider with ChangeNotifier {
  bool autoMode = true;

  void switchAutoMode() {
    autoMode = !autoMode;
    notifyListeners();
  }
}
