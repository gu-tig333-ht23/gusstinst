import 'package:flutter/material.dart';

class DateTimeProvider extends ChangeNotifier {
  DateTime _selectedDateTime =
      DateTime(0000, 00, 00, 00, 00); // as default when not chosen

  DateTime get selectedDateTime => _selectedDateTime;

  Future<void> updateSelectedDateTime(
      DateTime selectedDate, TimeOfDay selectedTime) async {
    _selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    notifyListeners();
  }

  // updates the selected time
  Future<void> updateSelectedTime(TimeOfDay selectedTime) async {
    _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        selectedTime.hour,
        selectedTime.minute);
    notifyListeners();
  }

  // updates the selected date
  Future<void> updateSelectedDate(DateTime selectedDate) async {
    _selectedDateTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, _selectedDateTime.hour, _selectedDateTime.minute);
    notifyListeners();
  }
}
