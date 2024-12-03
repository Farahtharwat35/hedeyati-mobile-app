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
  final String filter;
  @override
  _EventsListPageState createState() => _EventsListPageState(filter: filter);

  final String sortBy;

  const EventsListPage({super.key, required this.filter,this.sortBy=""});
}

class _EventsListPageState extends State<EventsListPage> {
  List<Event> upcoming_events = [];
  List<Event> current_events = [];
  List<Event> past_events = [];
  List<String> names = ["John", "Alice", "Bob", "Charlie", "David", "Eve", "Frank", "Grace", "Helen", "Ivy" , "Jack", "Kate", "Liam", "Mia", "Noah" , "Olivia", "Peter", "Quinn", "Rose", "Sam", "Tina", "Uma", "Victor", "Wendy", "Xander", "Yara", "Zane"];

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
    setState(() {
      filter_by_date(newEvent);
    });
  }

   List<Event> sortEventsByName(events) {
    events.sort((a, b) => a.owner.compareTo(b.owner));
    return events;
  }

  List<Event> getEvents (events) {
    if (filter == "upcoming") {
      return upcoming_events;
    }
    else if (filter == "current") {
      return current_events;
    }
    else if (filter == "past") {
      return past_events;
    }
    else {
      return events;
    }
  }

  void filter_by_date(newEvent) {
    if (newEvent.date.isAfter(DateTime.now())) {
      upcoming_events.add(newEvent);
    } else if (newEvent.date.isBefore(DateTime.now())) {
      past_events.add(newEvent);
    } else {
      current_events.add(newEvent);
    }
  }

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= 15; i++) {
      Future.delayed(const Duration(milliseconds: 5), () {
        Random random = Random();

        // Generate a random integer between -5 and 5
        int randomDays = random.nextInt(11) - 5;
        EventCategory category = EventCategory.values[random.nextInt(EventCategory.values.length)];

        addEvent(
          " is celebrating his ${category.toString().split('.').last}!",
          "https://images.squarespace-cdn.com/content/v1/60da576b8b440e12699c9263/1650354559198-U58EM4C8OL0QIVOW3CSN/Ovation.jpg?format=2500w",
          category,
          DateTime.now().add(Duration(days: randomDays)),
          names[random.nextInt(names.length)],
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
            subtitle: Text("${event.date.day}/${event.date.month}/${event.date.year}"),
            trailing: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Edit event Page
                      },
                    ),
                   IconButton(onPressed: () {
                      setState(() {
                        filteredEvents.removeAt(index);
                      });
                   }
                       , icon: const Icon(Icons.delete))
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
