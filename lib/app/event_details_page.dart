import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hedeyati/app/reusable_components/card_for_details.dart';
import '../bloc/events/event_bloc.dart';
import '../bloc/generic_bloc/generic_crud_events.dart';
import '../models/event.dart';

void showEventDetails(BuildContext context, Event event, EventBloc eventBloc) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        child: Material(
          color: Colors.transparent,
          child: buildDetailPage(
            context: context,
            title: event.name,
            subtitle: "",
            widgetsAxisAlignment: CrossAxisAlignment.center,
            content: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  event.image.isNotEmpty
                      ? event.image
                      : 'https://th.bing.com/th/id/R.38be526e30e3977fb59c88f6bdc21693?rik=JeWAtcDhYBB8Qg&riu=http%3a%2f%2fsomethingdifferentcompanies.com%2fwp-content%2fuploads%2f2016%2f06%2fevent-image.jpeg&ehk=zyr0vwrJU%2fDm%2bLN0rSy8QnSUSlmBCS%2bRxG7AeymborI%3d&risl=&pid=ImgRaw&r=0',
                ),
              ),
              const SizedBox(height: 16),
              // Event Description
              Center(
                child: Text(
                  event.description.isNotEmpty ? '${event.description}' : 'No description for this event',
                  style: const TextStyle(fontSize: 16, color: Colors.white70 , fontWeight: FontWeight.bold , fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Event Category: Birthday',
                  style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold , fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'On: ${DateFormat("dd/MM/yyyy").format(event.eventDate)}',
                  style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold , fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      return _confirmDelete(context, event, eventBloc);
                      // Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontStyle: FontStyle.italic, fontSize: 17),
                    ),
                  ),
                  const Icon(Icons.delete, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _confirmDelete(BuildContext context, Event event , EventBloc eventBloc) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
            'Are you sure you want to delete the event "${event.name}"?'),
        backgroundColor: Colors.pink[50],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              eventBloc.add(DeleteModel(event));
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
