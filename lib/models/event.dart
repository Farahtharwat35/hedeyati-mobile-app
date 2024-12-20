import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';


part 'event.g.dart';
@JsonSerializable()
// Event Class
class Event extends Model {
  @override
  String? id;
  final String? firestoreUserID;
  final String image;
  final String name;
  final String description;
  final int categoryID;
  final String eventDate;

  Event({
    this.id,
    this.firestoreUserID,
    required this.name,
    required this.description,
    required this.categoryID,
    required this.eventDate,
    required this.image
  });

  Event copyWith({
    required String? id,
    String? image,
    String? name,
    String? description,
    int? categoryID,
    String? eventDate,
    int? status,
    String? createdBy,
    DateTime? createdAt,
    DateTime? deletedAt,
    DateTime? updatedAt,
  }) {
    log('Creating copy of Event with id: $id');
    return Event(
      id: this.id,
      firestoreUserID: firestoreUserID,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryID: categoryID ?? this.categoryID,
      eventDate: eventDate ?? this.eventDate,
    ) ..createdAt = this.createdAt
      ..updatedAt = this.updatedAt
      ..deletedAt = this.deletedAt
      ..isDeleted = isDeleted;
  }


  factory Event.fromJson(Map<String, dynamic> json) {
    log('Parsing Event JSON: $json');
    try {
      return _$EventFromJson(json);
    } catch (e, stack) {
      log('Error while parsing Event JSON: $e\nStack Trace: $stack', error: e, stackTrace: stack);
      log('Problematic JSON: $json');
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final json = _$EventToJson(this);
    log('Converting Event to JSON: $json');
    return json;
  }

  static get instance {
    log('Initializing Firestore Collection Reference for Events');
    try {
      return FirebaseFirestore.instance.collection('Events').withConverter<Event>(
        fromFirestore: (snapshot, _) {
          log('Fetching Event from Firestore: ${snapshot.id}');
          final data = snapshot.data();
          if (data != null) {
            log('Event Data from Firestore: $data');
            return Event.fromJson({...data, 'id': snapshot.id});
          } else {
            log('No data found for document ID: ${snapshot.id}');
            throw Exception('No data found in Firestore document');
          }
        },
        toFirestore: (event, _) {
          final json = _$EventToJson(event);
          log('Saving Event to Firestore: $json');
          return json;
        },
      );
    } catch (e, stack) {
      log('Error initializing Firestore Collection Reference: $e\nStack Trace: $stack', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  CollectionReference<Event> getReference() {
    log('Getting Event Collection Reference');
    return instance;
  }

  static Event dummy() {
    log('Creating dummy Event instance');
    return Event(
      image: '',
      firestoreUserID: '',
      name: '',
      description: '',
      categoryID: 0,
      eventDate: DateTime.now().toIso8601String(),
    );
  }

  @override
  String toString() {
    return 'Event{firestoreUserID: $firestoreUserID, image: $image, name: $name, description: $description, categoryID: $categoryID, eventDate: $eventDate, createdAt: $createdAt, deletedAt: $deletedAt}';
  }
}
