import 'package:flutter/material.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/models/gift.dart';
import 'package:hedeyati/app/reusable_components/app_theme.dart';
import 'package:hedeyati/app/reusable_components/build_text_field_widget.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import '../../bloc/gifts/gift_bloc.dart';

class AddGift extends StatefulWidget {
  const AddGift({super.key});

  @override
  State<AddGift> createState() => _AddGiftPage();
}

class _AddGiftPage extends State<AddGift> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryIDController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Add Gift', textAlign: TextAlign.center),
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
                          buildTextField(controller: _descriptionController, args: {'labelText': 'Gift Description', 'prefixIcon': Icons.card_giftcard}),
                          buildTextField(controller: _priceController, args: {'labelText': 'Price', 'prefixIcon': Icons.attach_money, 'keyboardType': TextInputType.number}),
                          buildTextField(controller: _categoryIDController, args: {'labelText': 'Category ID', 'prefixIcon': Icons.category, 'keyboardType': TextInputType.number}),
                          const SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final gift = Gift(
                                    eventID: 'example-event-id',
                                    description: _descriptionController.text,
                                    price: double.parse(_priceController.text),
                                    categoryID: int.parse(_categoryIDController.text),
                                  );
                                  GiftBloc.get(context).add(AddModel(gift));
                                  if (GiftBloc.get(context).state is ModelAddedState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Gift added successfully!',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                        ),
                                        backgroundColor: Colors.pinkAccent,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Failed to add gift',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Add Gift', style: TextStyle(fontSize: 18)),
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
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryIDController.dispose();
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
                "Gift",
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GreatVibes',
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.card_giftcard, color: Colors.pinkAccent, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}
