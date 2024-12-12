import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<MySearchBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        // onChanged: onQueryChanged,
        decoration: InputDecoration(
          labelText: 'Search',
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: myTheme.colorScheme.primary),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}