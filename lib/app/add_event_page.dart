import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/helpers/userCredentials.dart';
import 'package:hedeyati/models/event.dart';
import 'package:hedeyati/app/app_theme.dart';
import 'package:intl/intl.dart';

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

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Keep the form's size minimal
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(_nameController, 'Event Name', Icons.event),
                      _buildTextField(_descriptionController, 'Description', Icons.description),
                      _buildTextField(_categoryIDController, 'Category ID', Icons.category),
                      _buildDatePickerField(_startDateController, 'Start Date', context),
                      _buildDatePickerField(_endDateController, 'End Date', context),
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
                          child: const Text('Create Event', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pinkAccent), // PinkAccent when focused
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pinkAccent), // PinkAccent when enabled
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pinkAccent), // PinkAccent when focused
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pinkAccent), // PinkAccent when enabled
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty || DateTime.tryParse(value) == null) {
            return 'Please select a valid $label';
          }
          return null;
        },
        readOnly: true,
        onTap: () => _selectDate(context, controller),
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
