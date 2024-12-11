import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async_builder/async_builder.dart';
import '../bloc/events/event_bloc.dart';
import '../models/event.dart';
import '../app/app_theme.dart';
import '../app/reusable_components/build_card.dart';
import 'edit_event_page.dart';
import 'event_details_page.dart';


class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late List<Stream<List<Event>>> _eventStreams;
  late EventBloc eventBloc;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _mainTabController.addListener(_onTabChanged);
    eventBloc = BlocProvider.of<EventBloc>(context);
    _eventStreams = [eventBloc.myEventsStream, eventBloc.friendsEventsStream];
  }

  @override
  void dispose() {
    _mainTabController.removeListener(_onTabChanged);
    _mainTabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_mainTabController.indexIsChanging) {
      setState(() {});
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
            child: AsyncBuilder<List<Event>>(
              stream: _eventStreams[_mainTabController.index],
              waiting: (context) =>
                  const Center(child: CircularProgressIndicator()),
              error: (context, error, stack) {
                debugPrint('Error: $error');
                debugPrint('Stack Trace: $stack');
                return Center(
                  child: Text('Error: $error'),
                );
              },
              builder: (context, events) {
                List<Widget> content = [];
                content.add(Center(
                  child: _mainTabController.index == 0
                      ? Text(
                          'My Events',
                          style: myTheme.textTheme.headlineMedium,
                        )
                      : Text(
                          'My Friends Events',
                          style: myTheme.textTheme.headlineMedium,
                        ),
                ));
                content.add(const SizedBox(height: 16));
                final filteredEvents = events?.where((event) => !event.isDeleted).toList();
                for (int i=0 ; i<filteredEvents!.length ; i++){
                  print("---------------------FILTERED EVENTS---------------------");
                  print(filteredEvents[i].toJson());
                }
                if (filteredEvents == null || filteredEvents.isEmpty) {
                content.add(const Center(child: Text('No events found.')));
                } else {
                content.addAll(
                filteredEvents.map((event) => _buildEventTile(context,event,eventBloc)).toList(),
                );
                }
                return buildCard(context, content);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, Event event , EventBloc eventBloc) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage( event.image.isNotEmpty
            ? event.image
            : 'https://th.bing.com/th/id/R.38be526e30e3977fb59c88f6bdc21693?rik=JeWAtcDhYBB8Qg&riu=http%3a%2f%2fsomethingdifferentcompanies.com%2fwp-content%2fuploads%2f2016%2f06%2fevent-image.jpeg&ehk=zyr0vwrJU%2fDm%2bLN0rSy8QnSUSlmBCS%2bRxG7AeymborI%3d&risl=&pid=ImgRaw&r=0'),
        radius: 25,
      ),
      title: Text(
        event.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        "${event.eventDate.day}/${event.eventDate.month}/${event.eventDate.year}",
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.pinkAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEvent(event: event , eventBloc: eventBloc),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye, // Eye icon
              color: Colors.pinkAccent),
            onPressed: () {
              showEventDetails(context, event, eventBloc);
            },
          ),
        ],
      ),
      onTap: () {
       // Navigator.push (context, MaterialPageRoute(builder: (context) => EventDetails(event: event)),);
      },
    );
  }
}
