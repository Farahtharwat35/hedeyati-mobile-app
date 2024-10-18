import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            title,
             style: Theme.of(context).textTheme.headlineMedium,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      toolbarHeight:70
      ),
      body: Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}