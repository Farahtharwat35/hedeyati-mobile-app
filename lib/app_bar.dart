import 'package:flutter/material.dart';
import 'package:hedeyati/app_theme.dart';

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
      bottom: TabBar(
        indicatorColor: myTheme.colorScheme.surface,
        labelColor: myTheme.colorScheme.surface,
        unselectedLabelColor: Colors.black,
        dividerColor: Colors.black,
        tabs: const <Widget>[
          Tab(
            text: 'Home',
            icon: Icon(Icons.home),

          ),
          Tab(
            text: 'Events',
            icon: Icon(Icons.calendar_month),
          ),
          Tab(
            text: 'Notifications',
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 58.0);
}