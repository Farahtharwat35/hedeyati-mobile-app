import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/bloc/friendship/friendship_bloc.dart';
import 'package:hedeyati/app/reusable_components/build_text_field_widget.dart';
import 'package:hedeyati/helpers/query_arguments.dart';
import 'package:hedeyati/models/friendship.dart';
import 'package:hedeyati/bloc/user/user_bloc.dart';

import '../../bloc/friendship/frienship_events.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  String _selectedMethod = 'Username';
  late final FriendshipBloc friendshipBloc;

  @override
  void initState() {
    super.initState();
    friendshipBloc = context.read<FriendshipBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Add Friend', textAlign: TextAlign.center),
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
                          _buildDropdown(),
                          const SizedBox(height: 20),
                          buildTextField(
                            controller: _inputController,
                            args: {
                              'labelText': 'Enter ${_selectedMethod.toLowerCase()}',
                              'prefixIcon': _selectedMethod == 'Username'
                                  ? Icons.person
                                  : Icons.phone,
                              'keyboardType': _selectedMethod == 'Phone Number'
                                  ? TextInputType.phone
                                  : TextInputType.text,
                            },
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<UserBloc, ModelStates>(
                            listener: (context, userState) {
                              if (userState is ModelLoadingState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Checking User...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    backgroundColor: Colors.pinkAccent,
                                  ),
                                );
                              } else if (userState is ModelLoadedState) {
                                // User found, proceed to add friendship
                                String? receiverID = userState.models.first.id;
                                final newFriendship = Friendship(
                                  requesterID: FirebaseAuth.instance.currentUser!.uid,
                                  recieverID: receiverID!,
                                  members: [FirebaseAuth.instance.currentUser!.uid, receiverID],
                                );
                                context.read<FriendshipBloc>().add(AddFriend(newFriendship));
                              } else if (userState is ModelEmptyState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'User not found',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, userState) {
                              return BlocConsumer<FriendshipBloc, ModelStates>(
                                listener: (context, friendshipState) {
                                  if (friendshipState is ModelLoadingState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Preparing Your Friend Request...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        backgroundColor: Colors.pinkAccent,
                                      ),
                                    );
                                  } else if (friendshipState is ModelAddedState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Friend Request Sent Successfully! Waiting for approval',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        backgroundColor: Colors.pinkAccent,
                                      ),
                                    );
                                  } else if (friendshipState is ModelErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          friendshipState.message.message,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                                builder: (context, friendshipState) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _selectedMethod == 'Username'
                                            ? context.read<UserBloc>().add(LoadModel([
                                          {'username': QueryArg(isEqualTo: _inputController.text)}
                                        ]))
                                            : context.read<UserBloc>().add(LoadModel([
                                          {'phoneNumber': QueryArg(isEqualTo: _inputController.text)}
                                        ]));
                                      }
                                    },
                                    child: Center(child: const Text('Add Friend', style: TextStyle(fontSize: 18))),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedMethod,
      decoration: InputDecoration(
        labelText: 'Add by',
        labelStyle: TextStyle(
          color: Colors.pinkAccent,
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.pinkAccent),
        ),
      ),
      items: ['Username', 'Phone Number']
          .map(
            (method) => DropdownMenuItem(
          value: method,
          child: Text(method),
        ),
      )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedMethod = value!;
          _inputController.clear();
        });
      },
    );
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
                "Add Friend",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GreatVibes',
                  color: Colors.pinkAccent,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.group_add,
                  color: Colors.pinkAccent, size: 40),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
