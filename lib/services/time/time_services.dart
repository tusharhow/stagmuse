import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stagemuse/utils/export_utils.dart';

class TimeServices {
  // Process
  static Future<String?> selectDate({
    required BuildContext context,
    required String? tanggal,
  }) async {
    // Convert
    var selectedDate =
        (tanggal != null) ? DateTime.parse(tanggal) : DateTime.now();
    // Show Date Picker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(2025),
    );
    // Check if selected date != true dae
    if (picked != selectedDate && picked != null) {
      // Update selected date to active date
      selectedDate = picked;

      // Convert
      final String _convert = DateFormat('yyyy-MM-dd').format(selectedDate);

      return _convert;
    }
  }

  static Future<String?> selectTime({
    required BuildContext context,
    required String? time,
  }) async {
    // Convert
    final format = DateFormat.jm();
    TimeOfDay selectedTime = (time == null)
        ? TimeOfDay.now()
        : TimeOfDay.fromDateTime(format.parse(time));
    // Show Date Picker
    final picked = await showTimePicker(
      context: context,
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light().copyWith(
            primary: colorPrimary,
            secondary: colorSecondary,
            onSurface: colorBackground,
            surface: colorThird,
            background: colorBackground,
          ),
        ),
        child: child!,
      ),
      initialTime: selectedTime,
    );

    // Check if selected time != true time
    if (picked != selectedTime && picked != null) {
      // Update selected time to active time
      selectedTime = picked;

      // Convert
      final now = DateTime.now();
      final dateTime = DateTime(
          now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
      final format = DateFormat.jm().format(dateTime);

      return format;
    }
  }
}
