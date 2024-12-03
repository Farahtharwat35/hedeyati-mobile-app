import 'package:flutter/material.dart';

Widget buildTextField(TextEditingController controller, String label, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent), // PinkAccent when focused
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent), // PinkAccent when enabled
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    ),
  );
}