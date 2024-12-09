import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/helpers/userCredentials.dart';
import 'package:hedeyati/models/event.dart';
import 'package:hedeyati/app/app_theme.dart';
import 'package:provider/provider.dart';
import '../bloc/events/event_bloc_events.dart';
import 'package:hedeyati/app/reusable_components/build_text_field_widget.dart';
import 'package:hedeyati/app/reusable_components/date_picker_field_widget.dart';

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
        backgroundColor: Colors.white, // Keep the background white
        appBar: AppBar(
          title: const Text('Create Event', textAlign: TextAlign.center),
          titleTextStyle: Theme.of(context).textTheme.headlineMedium,
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true, // Center the title
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context), // Go back to previous screen
          ),
        ),
        body: Center( // Center the form in the middle of the screen
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 8, // Adjusted elevation for a softer look
              shadowColor: Colors.black.withOpacity(0.8), // Subtle shadow
              color: Color(0xFFF1F1F1), // Soft light gray card background
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(), // Add header here
                    const SizedBox(height: 20), // Space between header and form
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Keep the form's size minimal
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTextField(_nameController, 'Event Name', Icons.event),
                          buildTextField(_descriptionController, 'Description', Icons.description),
                          buildTextField(_categoryIDController, 'Category ID', Icons.category),
                          buildDatePickerField(_startDateController, 'Start Date', context),
                          buildDatePickerField(_endDateController, 'End Date', context),
                          const SizedBox(height: 20),
                          Center( // Center the button
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40), // Button width based on content
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: userFirestoreID == null
                                  ? null // Disable button until credentials are loaded
                                  : () async {
                                if (_formKey.currentState!.validate()) {
                                  final event = Event(
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

                                  Provider.of<EventBloc>(context).add(AddEvent(event));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Event added successfully!')),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Create Event', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
    _startDateController.dispose();
    _endDateController.dispose();
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
              const SizedBox(width: 10), // Space between icon and text
              Icon(Icons.event, color: Colors.pinkAccent, size: 40), // Event icon
            ],
          ),
        ],
      ),
    );
  }
}
