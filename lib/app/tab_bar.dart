import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hedeyati/app/reusable_components/app_bar.dart';
import 'package:hedeyati/app/home_page.dart';
import 'package:hedeyati/app/notifications_page.dart';
import 'package:hedeyati/app/events_list_page.dart';
import 'package:hedeyati/app/tab_bar_friendslist.dart';
import 'app_theme.dart';


class MyTabBar extends StatelessWidget {

  const MyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(title: 'Hedeyati'),
        body: TabBarView(
          children: <Widget>[
            HomePage(),
            NestedTabBar('EVENTS'),
            NotificationPage(),
            // NestedTabBar('Explore'),
          ],
        ),
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar(this.outerTab, {super.key});

  final String outerTab;

  @override
  State<NestedTabBar> createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  EventsListPage upcoming = const EventsListPage(filter: 'upcoming');
  EventsListPage current = const EventsListPage(filter: 'current');
  EventsListPage past = const EventsListPage(filter: 'past');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TabBar.secondary(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(text: 'upcoming', icon: Icon(Icons.calendar_today)),
              Tab(text: 'current', icon: Icon(Icons.calendar_view_day)),
              Tab(text: 'past', icon: Icon(Icons.alarm_rounded)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    // Navigate to the details page for the upcoming event
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyTabBarFriendList(), // You can pass the relevant event details here
                      ),
                    );
                  },
                  child: Card(
                    child: upcoming,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigate to the details page for the current event
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyTabBarFriendList(), // Pass relevant details
                      ),
                    );
                  },
                  child: Card(
                    child: current,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Navigate to the details page for the past event
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyTabBarFriendList() // Pass relevant details
                      ),
                    );
                  },
                  child: Card(
                    child: past,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.sort,
        foregroundColor: myTheme.colorScheme.onPrimary,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.text_fields),
            label: 'Name',
            onTap: () {
              setState(() {
              }); // Example tap handler
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.category),
            label: 'Category',
            onTap: () {
              // Update filter or sort settings here if needed
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
