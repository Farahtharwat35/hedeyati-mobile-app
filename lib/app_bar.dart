import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      titleTextStyle: Theme
          .of(context)
          .textTheme
          .headlineMedium,
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}