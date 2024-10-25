import 'dart:math';
import 'package:flutter/material.dart';



// Event model
class Event {
  final EventCategory Category;
  final String description;
  final DateTime date;
  final String EventAvatar;
  final String owner;

  Event({
    required this.description,
    required this.date,
    required this.EventAvatar,
    required this.Category,
    required this.owner
  });
}

enum EventCategory {
  Birthday,
  Anniversary,
  Graduation,
  Wedding,
}

class EventsListPage extends StatefulWidget {
  @override
  _EventsListPageState createState() => _EventsListPageState(filter: filter);

  final String filter;
  final String sortBy;

  EventsListPage({Key? key, required this.filter,this.sortBy=""}) : super(key: key);
}

class _EventsListPageState extends State<EventsListPage> {
  List<Event> upcoming_events = [];
  List<Event> current_events = [];
  List<Event> past_events = [];

  var filter;
  var sortBy = "";


  _EventsListPageState({required this.filter});

  void addEvent(String description, String EventAvatar, EventCategory Category , DateTime Date , String owner) {
    final newEvent = Event(
      description: owner + description,
      date: Date,
      EventAvatar: EventAvatar,
      Category: Category,
      owner: owner
    );



    void sortEventsByName() {
      upcoming_events.sort((a, b) => a.owner.compareTo(b.owner));
      current_events.sort((a, b) => a.owner.compareTo(b.owner));
      past_events.sort((a, b) => a.owner.compareTo(b.owner));
    }

    void filter_by_date() {
      if (newEvent.date.isAfter(DateTime.now())) {
        upcoming_events.add(newEvent);
      } else if (newEvent.date.isBefore(DateTime.now())) {
        past_events.add(newEvent);
      } else {
        current_events.add(newEvent);
      }
    }

    setState(() {
      filter_by_date();
      if (sortBy == "name") {
        sortEventsByName();
      }
    });
  }


  @override
  void initState() {
    super.initState();

    // Create 15 sample events
    for (int i = 1; i <= 15; i++) {
      Future.delayed(Duration(seconds: 2), () {
        Random random = Random();

        // Generate a random integer between -5 and 5
        int randomDays = random.nextInt(11) - 5;
        EventCategory category = EventCategory.values[random.nextInt(EventCategory.values.length)];

        addEvent(
          " is celebrating his ${category.toString().split('.').last}!",
          "https://images.squarespace-cdn.com/content/v1/60da576b8b440e12699c9263/1650354559198-U58EM4C8OL0QIVOW3CSN/Ovation.jpg?format=2500w",
          category,
          DateTime.now().add(Duration(days: randomDays)),
          "Owner $i",
        );
      });
    }
  }

  List<Event> get filteredEvents {
    switch (filter) {
      case "upcoming":
        return upcoming_events;
      case "current":
        return current_events;
      case "past":
        return past_events;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(event.EventAvatar),
              radius: 25,
            ),
            title: Text(event.description),
            subtitle: Text(event.date.day.toString() + "/" + event.date.month.toString() + "/" + event.date.year.toString()),
            trailing: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Edit event Page
                      },
                    ),
                   IconButton(onPressed: () {
                      setState(() {
                        filteredEvents.removeAt(index);
                      });
                   }
                       , icon: Icon(Icons.delete))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}