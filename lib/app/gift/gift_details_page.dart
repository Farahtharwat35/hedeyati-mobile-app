import 'package:flutter/material.dart';
import 'package:hedeyati/app/reusable_components/delete_dialog.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_bloc.dart';
import 'package:intl/intl.dart';
import 'package:hedeyati/app/reusable_components/card_for_details.dart';
import '../../bloc/gifts/gift_bloc.dart';
import '../../models/gift.dart';
import '../../models/model.dart';

void showGiftDetails(BuildContext context, Gift gift, GiftBloc giftBloc) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return buildDetailPage(
        context: context,
        title: gift.name,
        subtitle: "",
        widgetsAxisAlignment: CrossAxisAlignment.center,
        content: [
          // Gift Description
          Center(
            child: Text(
              gift.description.isNotEmpty ? gift.description : 'No description for this gift',
              style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Gift Category: ${gift.categoryID.isNotEmpty ? gift.categoryID : "Unknown"}',
              style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Added On: ${DateFormat("dd/MM/yyyy").format(gift.createdAt!)}',
              style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              gift.isPledged
                  ? 'Pledged by: ${gift.pledgedBy != null? gift.pledgedBy : "Unknown"}'
                  : 'Not Pledged',
              style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  return confirmDelete(
                    context,
                    giftBloc as ModelBloc,
                    gift as Model,
                    Text('Are you sure you want to delete the gift "${gift.name}"?'),
                  );
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 17),
                ),
              ),
              const Icon(Icons.delete, color: Colors.white),
            ],
          ),
        ],
      );
    },
  );
}
