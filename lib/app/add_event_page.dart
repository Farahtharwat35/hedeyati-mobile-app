import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/helpers/userCredentials.dart';
import 'package:hedeyati/models/event.dart';
import 'package:hedeyati/app/app_theme.dart';

import '../bloc/events/event_bloc_events.dart';


class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryIDController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String? userFirestoreID;

  @override
  void initState() {
    super.initState();
    _loadUserCredientials();
  }

  Future<void> _loadUserCredientials() async {
    final credentials = await UserCredentials.getCredentials(); // Await the Future
    setState(() {
      userFirestoreID = credentials; // Update state with the resolved value
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme, // Apply custom theme here
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 70, 0),
              child: Text('Create Event'),
            ),
          ),
          titleTextStyle: Theme.of(context).textTheme.headlineMedium,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Event Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextFormField(
                  controller: _categoryIDController,
                  decoration: const InputDecoration(labelText: 'Category ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Please enter a valid category ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startDateController,
                  decoration: const InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
                  validator: (value) {
                    if (value == null || DateTime.tryParse(value) == null) {
                      return 'Please enter a valid start date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _endDateController,
                  decoration: const InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && DateTime.tryParse(value) == null) {
                      return 'Please enter a valid end date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: userFirestoreID == null
                      ? null // Disable button until credentials are loaded
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      final event = Event(
                        firestoreID: '', // Firestore generates this ID
                        firestoreUserID: userFirestoreID!,
                        name: _nameController.text,
                        description: _descriptionController.text,
                        categoryID: int.parse(_categoryIDController.text),
                        startDate: DateTime.parse(_startDateController.text),
                        endDate: DateTime.parse(_endDateController.text),
                        status: 1, // Default status
                        createdBy: userFirestoreID!,
                        createdAt: DateTime.now(),
                      );

                      BlocProvider.of<EventBloc>(context).add(AddEvent(event));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Event added successfully!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Create Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryIDController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}
