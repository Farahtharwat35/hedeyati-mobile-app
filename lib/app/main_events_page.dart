import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/app_bar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  late TabController _mainTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TabBar(
              controller: _mainTabController,
              tabs: const [
                Tab(text: 'My Events'),
                Tab(text: 'Others Events'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _mainTabController,
              children: const [
                FriendsEventsTab(),
                MyEventsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Sample content for 'All Events' Tab
class FriendsEventsTab extends StatelessWidget {
  const FriendsEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        EventCard(title: 'Event 1'),
        EventCard(title: 'Event 2'),
        EventCard(title: 'Event 3'),
      ],
    );
  }
}

// Sample content for 'My Events' Tab
class MyEventsTab extends StatelessWidget {
  const MyEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        EventCard(title: 'My Event 1'),
        EventCard(title: 'My Event 2'),
        EventCard(title: 'My Event 3'),
      ],
    );
  }
}

// A reusable event card widget
class EventCard extends StatelessWidget {
  final String title;

  const EventCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Add action for tap
        },
      ),
    );
  }
}

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key, required this.eventType});

  final String eventType;

  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar> with TickerProviderStateMixin {
  late TabController _subTabController;

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _subTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.eventType),  // Use your existing app bar here
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: TabBar(
              controller: _subTabController,
              labelColor: Colors.pinkAccent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.pinkAccent,
              tabs: const [
                Tab(text: 'Upcoming', icon: Icon(Icons.calendar_today)),
                Tab(text: 'Current', icon: Icon(Icons.calendar_view_day)),
                Tab(text: 'Past', icon: Icon(Icons.alarm_rounded)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _subTabController,
              children: [
                _buildEventCard('${widget.eventType} - Upcoming Events'),
                _buildEventCard('${widget.eventType} - Current Events'),
                _buildEventCard('${widget.eventType} - Past Events'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.pink[50], // Soft pink background for cards
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
