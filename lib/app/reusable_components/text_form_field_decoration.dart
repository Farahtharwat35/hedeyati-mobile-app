import 'package:flutter/material.dart';

InputDecoration textFormFieldDecoration(Map<String,dynamic> args){
  return InputDecoration(
    prefixIcon: args['prefixIcon'],
    labelText: args['labelText'] ?? args['hintText'],
    hintText: args['hintText'] ?? args['labelText'],
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.pinkAccent), // PinkAccent when focused
      borderRadius: BorderRadius.circular(16),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.pinkAccent), // PinkAccent when enabled
      borderRadius: BorderRadius.circular(16),
    ),
  );
}

String? Function(String?)? textFormFieldEmptyValidator(Map<String,dynamic> args){
  return (value) {
    final label = args['labelText'] ?? 'this field';
    if (value == null || value.isEmpty) {
      return 'Please enter $label';
    }
    return null;
  };
}
