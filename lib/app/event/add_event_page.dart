import 'dart:developer';
import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/event_category/event_category_bloc.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/models/event.dart';
import 'package:hedeyati/app/reusable_components/build_text_field_widget.dart';
import 'package:hedeyati/app/reusable_components/date_picker_field_widget.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/models/event_category.dart';

import '../../bloc/events/event_events.dart';
import '../reusable_components/text_form_field_decoration.dart';

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
  String? selectedCategoryId;

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
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            key: Key('create_event_card'), // Added key for the card widget
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.8),
            color: Color(0xFFF1F1F1),
            child: AsyncBuilder<List<EventCategory>>(
                key: Key('async_event_category_builder'), // Key for AsyncBuilder
                stream: EventCategoryBloc.get(context).eventCategoryBlocStream,
                waiting: (context) => const Center(child: CircularProgressIndicator()),
                error: (context, error, stack) {
                  log('Error: $error');
                  log('Stack Trace: $stack');
                  return Center(
                    child: Text('Error: $error'),
                  );
                },
                builder: (context, categories) {
                  return Padding(
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
                              buildTextField(
                                key: Key('event_name_field'), // Key for event name field
                                controller: _nameController,
                                args: {'labelText': 'Event Name', 'prefixIcon': Icons.event, 'maxLength': 10},
                              ),
                              buildTextField(
                                key: Key('description_field'), // Key for description field
                                controller: _descriptionController,
                                args: {'labelText': 'Description', 'prefixIcon': Icons.description, 'maxLines': 3, 'hintText': 'Enter a description (Optional)'},
                                emptyValidator: false,
                              ),
                              _buildCategoryDropdown(categories!),
                              buildDatePickerField(
                                  key: Key('event_date_field'), // Key for event date picker field
                                  _eventDateController, 'Event Date', context
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        key: Key('create_event_button'), // Key for create event button
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
                                              categoryID: selectedCategoryId!,
                                              eventDate: DateTime.parse(_eventDateController.text).toIso8601String(),
                                            );
                                            EventBloc.get(context).add(AddModel(event));
                                          }
                                        },
                                        child: const Text('Create Event', style: TextStyle(fontSize: 16)),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        key: Key('save_for_later_button'), // Key for save for later button
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          backgroundColor: Colors.grey,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!.validate()) {
                                            final event = Event(
                                              image: '',
                                              firestoreUserID: userFirestoreID,
                                              name: _nameController.text,
                                              description: _descriptionController.text,
                                              categoryID: selectedCategoryId!,
                                              eventDate: DateTime.parse(_eventDateController.text).toIso8601String(),
                                            );
                                            EventBloc.get(context).add(SaveEventLocally(event));
                                          }
                                        },
                                        child: const Text('Save For Later', style: TextStyle(fontSize: 16)),
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
                            if (EventBloc.get(context).state is ModelLoadingState) {
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
                            return Container();
                          },
                        ),
                      ],
                    ),
                  );
                }
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
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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

  Widget _buildCategoryDropdown(List<EventCategory> categories) {
    return DropdownButtonFormField<String>(
      key: Key('category_dropdown'), // Key for the category dropdown
      decoration: fieldDecorator({
        'labelText': 'Select Category',
        'prefixIcon': Icons.category,
      }),
      value: selectedCategoryId,
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category.id,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategoryId = value!;
        });
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }
}

