import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/events/event_bloc.dart';
import 'events_list_page.dart';

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
    _mainTabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _mainTabController.removeListener(_onTabChanged);
    _mainTabController.dispose();
    super.dispose();
  }

  Future<dynamic> _onTabChanged() async {
    if (_mainTabController.indexIsChanging) {
      final filter = _mainTabController.index == 0 ? 'My Events' : 'Others Events';
      print("Filter is $filter");
      print("--------------TAB SWITCHED--------------");
      return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Provider<EventBloc> (
            create: (_) => EventBloc(),
            child: EventsListPage(
              filter: filter,
            ),
          ),
          ),
      );
    }
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
                children: [
                  _buildEventList('My Events'),
                  _buildEventList('Others Events'),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildEventList(String filter) {
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
              filter,
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
