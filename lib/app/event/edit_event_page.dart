import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/build_text_field_widget.dart';
import 'package:hedeyati/bloc/events/event_bloc.dart';
import 'package:hedeyati/bloc/events/event_events.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/models/event.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/app/reusable_components/date_picker_field_widget.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/models/event_category.dart';
import 'package:intl/intl.dart';

import '../../bloc/event_category/event_category_bloc.dart';
import '../reusable_components/text_form_field_decoration.dart';

class EditEvent extends StatefulWidget {
  final Event event;
  final bool isLocalEvent;
  final EventBloc eventBloc;


  const EditEvent({Key? key, required this.event, required this.eventBloc , required this.isLocalEvent}) : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEvent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryIDController;
  late TextEditingController _eventDateController;
  String? _selectedCategoryId ;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController = TextEditingController(text: widget.event.description);
    _categoryIDController = TextEditingController(text: widget.event.categoryID.toString());
    _eventDateController = TextEditingController(text: widget.event.eventDate);
    _selectedCategoryId = widget.event.categoryID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Edit Event', textAlign: TextAlign.center),
          titleTextStyle: Theme.of(context).textTheme.headlineMedium,
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
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
              color: const Color(0xFFF1F1F1),
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
                          buildTextField(controller: _nameController, args: {'labelText': 'Event Name', 'prefixIcon': Icons.event}),
                          buildTextField(controller: _descriptionController, args: {'labelText': 'Description', 'prefixIcon': Icons.description, 'maxLines': 3}, emptyValidator: false),
                          _buildEventCategoryDropdown(context),
                          buildDatePickerField(TextEditingController(
                            text: DateFormat("dd/MM/yyyy").format(DateTime.parse(_eventDateController.text))), 'Event Date', context),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final updatedEvent = widget.event.copyWith(
                                    id: widget.event.id,
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    categoryID: _selectedCategoryId,
                                    eventDate: DateTime.parse(_eventDateController.text).toIso8601String(),
                                    updatedAt: DateTime.now(),
                                  );
                                  widget.isLocalEvent ? widget.eventBloc.add(UpdateEventLocally(updatedEvent)) : widget.eventBloc.add(UpdateModel(updatedEvent));
                                  if(widget.eventBloc is ModelLoadingState){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Updating event...' , style: TextStyle(fontWeight: FontWeight.bold , fontStyle: FontStyle.italic)), backgroundColor: Colors.pinkAccent),
                                    );
                                  }
                                  else if (widget.eventBloc.state is ModelUpdatedState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Event updated successfully!' , style: TextStyle(fontWeight: FontWeight.bold , fontStyle: FontStyle.italic)), backgroundColor: Colors.pinkAccent , duration: Duration(seconds: 1)),
                                    );
                                  }
                                  else if (widget.eventBloc.state is ModelLoadedState){
                                    CircularProgressIndicator();
                                  }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed to update event' , style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)), backgroundColor: Colors.red),
                                    );
                                  }
                                  Navigator.pop(context);
                              }},
                              child: const Text('Update Event', style: TextStyle(fontSize: 18)),
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
      );
  }

  Widget _buildEventCategoryDropdown(context) {
    return AsyncBuilder<List<EventCategory>>(
      stream: EventCategoryBloc.get(context).eventCategoryBlocStream,
      waiting: (context) => const Center(child: CircularProgressIndicator()),
      error: (context, error, stack) {
        debugPrint('Error: $error');
        debugPrint('Stack Trace: $stack');
        return Center(
          child: Text('Error: $error'),
        );
      },
      builder: (context, events) {
        return DropdownButtonFormField<String>(
          decoration: fieldDecorator({
            'labelText': 'Select Event',
            'prefixIcon': Icons.event,
          }),
          value: _selectedCategoryId,
          items: events?.map((event) {
            return DropdownMenuItem(
              value: event.id,
              child: Text(event.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value!;
            });
          },
          validator: (value) =>
          value == null ? 'Please select an event' : null,
        );
      },
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

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Edit Event",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GreatVibes',
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.edit, color: Colors.pinkAccent, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}
