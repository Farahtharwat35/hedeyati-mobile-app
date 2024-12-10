import 'package:flutter/material.dart';

// This function builds a card with a light pink background color. //

Widget buildCard(BuildContext context, List<Widget> widgets) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      color: Colors.pink[50], // Light pink background color.
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
    ),
  );
}