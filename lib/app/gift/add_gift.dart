import 'dart:developer';

import 'package:async_builder/async_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/models/gift.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../bloc/gift_category/gift_category_events.dart';
import '../../bloc/gifts/gift_bloc.dart';
import '../../bloc/gift_category/gift_category_bloc.dart';
import '../../bloc/events/event_bloc.dart';
import '../../models/event.dart';
import '../../models/gift_category.dart';
import '../reusable_components/text_form_field_decoration.dart';
import '../reusable_components/build_text_field_widget.dart';

class AddGift extends StatefulWidget {
  const AddGift({super.key});

  @override
  State<AddGift> createState() => _AddGiftPage();
}

class _AddGiftPage extends State<AddGift> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _storesLocationRecommendationController =
      TextEditingController();

  late GiftCategoryBloc giftCategoryBloc;
  late EventBloc eventBloc;
  late GiftBloc giftBloc;

  late String? selectedCategoryId = null;
  late String? selectedEventId = null;

  @override
  void initState() {
    super.initState();
    giftCategoryBloc = GiftCategoryBloc.get(context);
    eventBloc = EventBloc.get(context);
    giftBloc = GiftBloc.get(context);
    giftCategoryBloc.add(GetAllGiftCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Gift', textAlign: TextAlign.center),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<GiftBloc, ModelStates>(
        builder: (context, state) {
          if (giftBloc.state is ModelLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (giftBloc.state is ModelAddedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Gift added successfully!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  backgroundColor: Colors.pinkAccent,
                ),
              );
              Navigator.pop(context);
            });
          } else if (giftBloc.state is ModelErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Failed to add gift',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }
          return Center(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextField(
                              controller: _nameController,
                              args: {
                                'labelText': 'Gift Name',
                                'prefixIcon': Icons.card_membership,
                              },
                            ),
                            buildTextField(
                              controller: _descriptionController,
                              args: {
                                'labelText': 'Gift Description',
                                'prefixIcon': Icons.card_giftcard,
                              },
                            ),
                            buildTextField(
                              controller: _priceController,
                              args: {
                                'labelText': 'Estimated Price (in \$)',
                                'prefixIcon': Icons.attach_money,
                                'keyboardType': TextInputType.number,
                              },
                            ),
                            buildTextField(
                              controller:
                                  _storesLocationRecommendationController,
                              args: {
                                'labelText': 'Recommended Stores',
                                'prefixIcon': Icons.shopping_bag_outlined,
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<GiftCategoryBloc, ModelStates>(
                              builder: (context, state) {
                                if (state is ModelLoadingState) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state is ModelLoadedState) {
                                  final categories =
                                      state.models as List<GiftCategory>;
                                  return _buildCategoryDropdown(categories);
                                } else {
                                  return const Center(
                                      child: Text('Failed to load categories'));
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildEventDropdown(),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                onPressed: () async {
                                  log("Firebase Auth: ${FirebaseAuth.instance.currentUser!.uid}");
                                  if (_formKey.currentState!.validate() &&
                                      selectedCategoryId != null &&
                                      selectedEventId != null) {
                                    final gift = Gift(
                                      eventID: selectedEventId!,
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      price:
                                          double.parse(_priceController.text),
                                      categoryID: selectedCategoryId!,
                                      firestoreUserID: FirebaseAuth.instance.currentUser!.uid,
                                    );
                                    GiftBloc.get(context).add(AddModel(gift));
                                  }
                                },
                                child: const Text('Add Gift',
                                    style: TextStyle(fontSize: 18)),
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
          );
        },
      ),
    );
  }

  Widget _buildCategoryDropdown(List<GiftCategory> categories) {
    return DropdownButtonFormField<String>(
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

  Widget _buildEventDropdown() {
    return AsyncBuilder(
        future: eventBloc.initializeStreams(),
        waiting: (context) => const Center(child: CircularProgressIndicator()),
        error: (context, error, stack) {
          debugPrint('Error: $error');
          debugPrint('Stack Trace: $stack');
          return Center(
            child: Text('Error: $error'),
          );
        },
        builder: (context, snapshot) {
          return AsyncBuilder<List<Event>>(
            stream: eventBloc.myEventsStream,
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
              return DropdownButtonFormField<String>(
                decoration: fieldDecorator({
                  'labelText': 'Select Event',
                  'prefixIcon': Icons.event,
                }),
                value: selectedEventId,
                items: events?.map((event) {
                  return DropdownMenuItem(
                    value: event.id,
                    child: Text(event.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEventId = value!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select an event' : null,
              );
            },
          );
        });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Gift",
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              fontFamily: 'GreatVibes',
              color: Colors.pinkAccent,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 40),
        ],
      ),
    );
  }
}
