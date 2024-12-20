import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:intl/intl.dart';
Widget buildDatePickerField(TextEditingController controller, String label, BuildContext context) {
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.calendar_today, color: myTheme.primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || DateTime.tryParse(value) == null) {
          return 'Please select a valid $label';
        }
        DateTime eventDate = DateTime.parse(value);
        if (eventDate.isBefore(DateTime.now())) {
          return 'Event date cannot be in the past';
        }
        return null;
      },
      readOnly: true,
      onTap: () => _selectDate(context, controller),
    ),
  );
}