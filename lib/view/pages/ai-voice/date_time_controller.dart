import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeController extends ChangeNotifier {
  DateTime? _selectedDateTime;

  DateTimeController([Timestamp? initialDateTime]) {
    _selectedDateTime = initialDateTime?.toDate();
  }

  DateTime? get selectedDateTime => _selectedDateTime;
  Timestamp? get firebaseTimestamp =>
      _selectedDateTime != null ? Timestamp.fromDate(_selectedDateTime!) : null;

  Timestamp requireTimestamp(String label) {
    if (_selectedDateTime == null) {
      throw StateError('$label is required but was not selected.');
    }
    return Timestamp.fromDate(_selectedDateTime!);
  }

  set selectedDateTime(DateTime? dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  void clear() {
    _selectedDateTime = null;
    notifyListeners();
  }
}
