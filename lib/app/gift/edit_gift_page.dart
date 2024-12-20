import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/events/event_bloc.dart';
import '../../bloc/generic_bloc/generic_crud_events.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../bloc/gift_category/gift_category_bloc.dart';
import '../../bloc/gift_category/gift_category_events.dart';
import '../../bloc/gifts/gift_bloc.dart';
import '../../models/event.dart';
import '../../models/gift.dart';
import '../../models/gift_category.dart';
import '../reusable_components/build_text_field_widget.dart';
import '../reusable_components/text_form_field_decoration.dart';

class EditGift extends StatefulWidget {
  final Gift gift;
  final GiftCategoryBloc giftCategoryBloc;
  final GiftBloc giftBloc;

  const EditGift({super.key, required this.giftCategoryBloc ,required this.giftBloc, required this.gift});

  @override
  State<EditGift> createState() => _EditGiftPage();
}

class _EditGiftPage extends State<EditGift> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _nameController;
  late TextEditingController _storesLocationRecommendationController;


  late String? selectedCategoryId;
  late String? selectedEventId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.gift.name);
    _descriptionController = TextEditingController(text: widget.gift.description);
    _priceController = TextEditingController(text: widget.gift.price.toString());
    selectedCategoryId = widget.gift.categoryID;
    selectedEventId = widget.gift.eventID;
    widget.giftCategoryBloc.add(GetAllGiftCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Gift', textAlign: TextAlign.center),
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
          if (widget.giftBloc.state is ModelLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (widget.giftBloc.state is ModelUpdatedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Gift updated successfully!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  backgroundColor: Colors.pinkAccent,
                ),
              );
              Navigator.pop(context);
            });
          } else if (widget.giftBloc.state is ModelErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Failed to update gift',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }
          return BlocBuilder<EventBloc, ModelStates>(
            builder: (context , state) {
              return AsyncBuilder<void>(
                future: EventBloc.get(context).initializeStreams(),
                builder: (context , _) {
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
                                    const SizedBox(height: 20),
                                    BlocBuilder<GiftCategoryBloc, ModelStates>(
                                      builder: (context, state) {
                                        if (state is ModelLoadingState) {
                                          return const Center(
                                              child: CircularProgressIndicator());
                                        } else if (state is ModelLoadedState) {
                                          final categories = state.models as List<GiftCategory>;
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
                                          if (_formKey.currentState!.validate() &&
                                              selectedCategoryId != null &&
                                              selectedEventId != null) {
                                            final updatedGift = widget.gift.copyWith(
                                              id: widget.gift.id,
                                              eventID: selectedEventId!,
                                              name: _nameController.text,
                                              description: _descriptionController.text,
                                              price: double.parse(_priceController.text),
                                              categoryID: selectedCategoryId!,
                                            );
                                            GiftBloc.get(context).add(UpdateModel(updatedGift));
                                          }
                                        },
                                        child: const Text('Update Gift',
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
                }
              );
            }
          );
        },
      ),

    );
  }

  Widget _buildCategoryDropdown(List<GiftCategory> categories) {
    if (!categories.any((category) => category.id == selectedCategoryId)) {
      selectedCategoryId = null;
    }
    // Log category ids for debugging
    for (var category in categories) {
      debugPrint('Category ID: ${category.id}, Category Name: ${category.name}');
    }
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
      validator: (value) =>
      value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildEventDropdown() {
    return AsyncBuilder<List<Event>>(
      stream: EventBloc.get(context).myEventsStream,
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
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Edit Gift",
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
