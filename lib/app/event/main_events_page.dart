import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:async_builder/async_builder.dart';
import 'package:hedeyati/bloc/event_category/event_category_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/helpers/listFiltering.dart';
import 'package:hedeyati/helpers/query_arguments.dart';
import 'package:provider/provider.dart';
import '../../bloc/events/event_bloc.dart';
import '../../bloc/events/event_events.dart';
import '../../bloc/events/event_states.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../bloc/gift_category/gift_category_bloc.dart';
import '../../bloc/gifts/gift_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../bloc/user/user_event.dart';
import '../../bloc/user/user_states.dart';
import '../../models/event.dart';
import '../../models/event_category.dart';
import '../gift/gifts_list_page.dart';
import '../reusable_components/app_theme.dart';
import '../reusable_components/build_card.dart';
import 'edit_event_page.dart';
import 'event_details_page.dart';
import 'package:hedeyati/helpers/listFiltering.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  late TabController _mainTabController;
  late List<Stream<List<Event>>> _eventStreams;
  late EventBloc eventBloc;
  late UserBloc userBloc;
  List<Event> localEvents = [];
  String _selectedFilter = 'All'; // Default filter

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _mainTabController.addListener(_onTabChanged);
    eventBloc = context.read<EventBloc>();
    eventBloc.add(GetEventsLocally());
    userBloc = context.read<UserBloc>();
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

  // Filtering logic for events
  List<Event> _applyFilter(List<Event> events) {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Upcoming':
        return filterList(events, (event) => DateTime.parse(event.eventDate).isAfter(now));
      case 'Past':
        return filterList(events, (event) => DateTime.parse(event.eventDate).isBefore(now));
      case 'Current':
        return filterList(events, (event) {
          final eventDate = DateTime.parse(event.eventDate);
          return eventDate.isAtSameMomentAs(now) ||
              (eventDate.isBefore(now) && eventDate.isAfter(now.subtract(Duration(days: 1))));
        });
      default:
        return events; // 'All'
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'All';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Upcoming'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Upcoming';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Past'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Past';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Current'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Current';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
            child: Column(
              children: [
                TabBar(
                  controller: _mainTabController,
                  tabs: const [
                    Tab(text: 'My Events'),
                    Tab(text: 'Others Events'),
                  ],
                ),
              ],
            ),
          ),
          BlocConsumer<EventBloc, ModelStates>(listener: (context, state) {
            if (state is ModelUpdatedState || state is ModelSuccessState) {
              context.read<EventBloc>().add(GetEventsLocally());
            }
          }, builder: (context, state) {
            if (state is LoadedLocalEvents) {
              localEvents = state.events;
            } else if (state is ModelEmptyState) {
              localEvents = [];
            }
            return Expanded(
              child: AsyncBuilder(
                  future: eventBloc.initializeStreams(),
                  waiting: (context) =>
                  const Center(child: CircularProgressIndicator()),
                  builder: (context, snapshot) {
                    _eventStreams = [
                      eventBloc.myEventsStream,
                      eventBloc.friendsEventsStream
                    ];
                    return AsyncBuilder<List<Event>>(
                      stream: _eventStreams[_mainTabController.index],
                      waiting: (context) =>
                      const Center(child: CircularProgressIndicator()),
                      builder: (context, events) {
                        final filteredEvents = _applyFilter(events ?? []);
                        final allEvents = _mainTabController.index == 0
                            ? [...filteredEvents, ...localEvents]
                            : filteredEvents;

                        if (allEvents.isEmpty) {
                          return buildCard(
                            context,
                            [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    _mainTabController.index == 0 ? 'My Events' : 'Friends Events',
                                    style: myTheme.textTheme.headlineMedium
                                  ),
                                ),
                              ),
                              Center(child: Text('No events found.')),
                            ],
                          );
                        }

                        return buildCard(
                          context,
                          [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  _mainTabController.index == 0 ? 'My Events' : 'Friends Events',
                                  style: myTheme.textTheme.headlineMedium,
                                ),
                              ),
                            ),
                            ...allEvents
                                .map((event) => _buildEventTile(context, event, eventBloc))
                                .toList(),
                          ],
                        );
                      },
                    );
                  }),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterBottomSheet,
        child: const Icon(Icons.filter_list),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }

  Widget _buildEventTile(
      BuildContext context, Event event, EventBloc eventBloc) {
    return BlocProvider(
      create: (_) =>
      UserBloc()..add(GetUserName(userId: event.firestoreUserID!)),
      child: BlocBuilder<UserBloc, ModelStates>(builder: (context, state) {
        String username = 'Unknown User';
        if (state is UserNameLoaded) {
          username = state.name;
        } else if (state is ModelErrorState) {
          username = 'Error loading username';
        }
        EventCategoryBloc.get(context).add(LoadModel([
          {'id': QueryArg(isEqualTo: event.categoryID)}
        ]));
        return BlocBuilder<EventCategoryBloc, ModelStates>(
            builder: (context, state) {
              if (state is ModelErrorState) {
                return const Center(child: Text('Error loading category'));
              } else if (state is ModelLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ModelEmptyState) {
                return const Center(child: Text('No category found'));
              } else if (state is ModelLoadedState) {
                DateTime eventDate = DateTime.parse(event.eventDate);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(event.image.isNotEmpty
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${eventDate.day}/${eventDate.month}/${eventDate.year}",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'From: $username',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (event.firestoreUserID ==
                          FirebaseAuth.instance.currentUser!.uid)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.pinkAccent),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider<EventBloc>(
                                          lazy: false,
                                          create: (BuildContext context) =>
                                          EventBloc()
                                            ..initializeStreams()
                                      ),
                                      BlocProvider<EventCategoryBloc>(
                                          create: (BuildContext context) =>
                                          EventCategoryBloc()
                                            ..initializeStreams()),
                                    ],
                                    child: EditEvent(
                                        event: event,
                                        isLocalEvent: localEvents.contains(event)
                                            ? true
                                            : false)),
                              ),
                            );
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye,
                            color: Colors.pinkAccent),
                        onPressed: () {
                          EventCategory category =
                          state.models.first as EventCategory;
                          localEvents.contains(event)
                              ? showEventDetails(
                              context, event, eventBloc, category.name,
                              isLocalEvent: true)
                              : showEventDetails(
                              context, event, eventBloc, category.name,
                              isLocalEvent: false);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            Provider<GiftBloc>(
                              create: (_) => GiftBloc(eventID: event.id),
                            ),
                            Provider<GiftCategoryBloc>(
                              create: (_) => GiftCategoryBloc(),
                            ),
                          ],
                          child:
                          GiftListPage(event: event, eventBloc: EventBloc()),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            });
      }),
    );
  }
}
