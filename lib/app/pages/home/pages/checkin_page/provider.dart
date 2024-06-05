import 'package:flutter/material.dart';

class CheckinProvider extends ChangeNotifier {
  int? checkInId;

  void setCheckinId(int id) {
    checkInId = id;
    notifyListeners();
  }
}
