import 'package:flutter/material.dart';

class StaffProvider with ChangeNotifier {
  String? _selectedStaffId;

  String? get selectedStaffId => _selectedStaffId;

  void setSelectedStaffId(String? id) {
    _selectedStaffId = id;
    notifyListeners();
  }
}
