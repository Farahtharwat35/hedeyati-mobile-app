import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/models/gift.dart';
import 'package:hedeyati/app/reusable_components/build_text_field_widget.dart';
import '../../bloc/generic_bloc/generic_states.dart';
import '../../bloc/gift_category/gift_category_events.dart';
import '../../bloc/gifts/gift_bloc.dart';
import '../../bloc/gift_category/gift_category_bloc.dart';
import '../../bloc/events/event_bloc.dart';
import '../../models/event.dart';
import '../../models/gift_category.dart';
import '../reusable_components/text_form_field_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_bloc.dart';
import 'package:hedeyati/bloc/gift_category/gift_category_events.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/models/gift_category.dart';
import '../reusable_components/text_form_field_decoration.dart';

class AddGift extends StatefulWidget {
  const AddGift({super.key});

  @override
  State<AddGift> createState() => _AddGiftPage();
}

class _AddGiftPage extends State<AddGift> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _storesLocationRecommendationController = TextEditingController();

  late GiftCategoryBloc giftCategoryBloc;

  late String? selectedCategoryId = null;

  @override
  void initState() {
    super.initState();
    giftCategoryBloc = GiftCategoryBloc.get(context);
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
      body: BlocBuilder<GiftCategoryBloc, ModelStates>(
        builder: (context, state) {
          if (state is ModelLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ModelErrorState) {
            return const Center(child: Text('Error loading categories'));
          } else if (state is ModelLoadedState) {
            final giftCategories = state.models;

            return SingleChildScrollView(
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
                              controller: _storesLocationRecommendationController,
                              args: {
                                'labelText': 'Recommended Stores',
                                'prefixIcon': Icons.shopping_bag_outlined,
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildCategoryDropdown(giftCategories as List<GiftCategory>), // Pass categories to the dropdown
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      selectedCategoryId != null) {
                                    // Add the gift with the selected category
                                    // GiftBloc.get(context).add(AddGiftEvent(...));
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
            );
          }

          return const Center(child: Text('No categories available'));
        },
      ),
    );
  }

  Widget _buildCategoryDropdown(List<GiftCategory> giftCategories) {
    return DropdownButtonFormField<String>(
      decoration: fieldDecorator({
        'labelText': 'Select Category',
        'prefixIcon': Icons.category,
      }),
      value: selectedCategoryId,
      items: giftCategories.map((category) {
        return DropdownMenuItem(
          value: category.id,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategoryId = value;
        });
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
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
