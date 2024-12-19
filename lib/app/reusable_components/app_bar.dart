import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';

import '../../authentication/signout.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:  Padding(
        padding: const EdgeInsets.fromLTRB(15,0,70,0),
        child: Center(child: Text(title)),
      ),
      titleTextStyle: Theme
          .of(context)
          .textTheme
          .headlineMedium,
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
      leading: IconButton(
        icon: ModalRoute.of(context)?.settings.name == '/tabBar' ? Icon(Icons.logout) : Icon(Icons.arrow_back),
        onPressed: () {
          if (ModalRoute.of(context)?.settings.name == '/tabBar') {
            Signout().signOut();
            Navigator.pushReplacementNamed(context, '/login');
          } else {
            Navigator.of(context).pop(); // Go back to the previous screen
          }
        },
      ),
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