import 'package:flutter/material.dart';
import 'package:hedeyati/bloc/events/event_events.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_bloc.dart';
import '../../bloc/generic_bloc/generic_crud_events.dart';
import '../../models/model.dart';

void confirmDelete(BuildContext context, ModelBloc bloc, Model model ,Text message , {bool isLocal = false}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: message,
        backgroundColor: Colors.pink[50],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              isLocal ? bloc.add(DeleteEventLocally(model.id!)) : bloc.add(DeleteModel(model));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}