import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/models/event.dart';
import 'package:hedeyati/app/reusable_components/build_text_field_widget.dart';
import 'package:hedeyati/app/reusable_components/date_picker_field_widget.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';

import '../../bloc/events/event_events.dart';

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
  final TextEditingController _eventDateController = TextEditingController();

  String userFirestoreID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Event', textAlign: TextAlign.center),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.8),
            color: Color(0xFFF1F1F1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField(controller: _nameController, args: {'labelText': 'Event Name', 'prefixIcon': Icons.event, 'maxLength': 10}),
                        buildTextField(controller: _descriptionController, args: {'labelText': 'Description', 'prefixIcon': Icons.description, 'maxLines': 3, 'hintText': 'Enter a description (Optional)'}, emptyValidator: false),
                        buildTextField(controller: _categoryIDController, args: {'labelText': 'Category ID', 'prefixIcon': Icons.category, 'keyboardType': TextInputType.number}),
                        buildDatePickerField(_eventDateController, 'Event Date', context),
                        const SizedBox(height: 20),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30), // Adjusted padding for smaller buttons
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final event = Event(
                                        image: '',
                                        firestoreUserID: userFirestoreID,
                                        name: _nameController.text,
                                        description: _descriptionController.text,
                                        categoryID: int.parse(_categoryIDController.text),
                                        eventDate: DateTime.parse(_eventDateController.text).toIso8601String(),
                                      );
                                      EventBloc.get(context).add(AddModel(event));
                                    }
                                  },
                                  child: const Text('Create Event', style: TextStyle(fontSize: 16)), // Smaller text
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30), // Adjusted padding for smaller buttons
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    backgroundColor: Colors.grey, // Color for "Save for Later"
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final event = Event(
                                        image: '',
                                        firestoreUserID: userFirestoreID,
                                        name: _nameController.text,
                                        description: _descriptionController.text,
                                        categoryID: int.parse(_categoryIDController.text),
                                        eventDate: DateTime.parse(_eventDateController.text).toIso8601String(),
                                      );
                                      EventBloc.get(context).add(SaveEventLocally(event));
                                    }
                                  },
                                  child: const Text('Save For Later', style: TextStyle(fontSize: 16)), // Smaller text
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  BlocBuilder<EventBloc, ModelStates>(
                    builder: (context, state) {
                      log('State is: ${EventBloc.get(context).state}');
                      if (EventBloc.get(context).state is ModelLoadingState) {
                        log('First IF - State is: ${EventBloc.get(context).state}');
                        Future.delayed(Duration.zero, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Adding event...',
                                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                              ),
                              backgroundColor: Colors.pinkAccent,
                            ),
                          );
                        });
                      } else if (EventBloc.get(context).state is ModelAddedState || EventBloc.get(context).state is ModelSuccessState) {
                        log('Second IF - State is: ${EventBloc.get(context).state}');
                        Future.delayed(Duration.zero, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Event added successfully!',
                                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                              ),
                              backgroundColor: Colors.pinkAccent,
                            ),
                          );
                        });
                      } else if (EventBloc.get(context).state is ModelErrorState) {
                        log('Third IF - State is: ${EventBloc.get(context).state}');
                        log('Error: ${(EventBloc.get(context).state as ModelErrorState).message.message}');
                        Future.delayed(Duration.zero, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Failed to add event',
                                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }
                      return Container(); // Return an empty container or any widget here as required.
                    },
                  ),
                ],
              ),
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
    _eventDateController.dispose();
    super.dispose();
  }

  _header() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20), // Adjust padding as needed
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Event",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GreatVibes',
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.event, color: Colors.pinkAccent, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}
