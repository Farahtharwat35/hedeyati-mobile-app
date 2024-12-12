import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';
part 'event_category.g.dart';

@JsonSerializable()
class EventCategory extends Model {
  @override
  String? id;
  final String name;

  EventCategory({
    this.id,
    required this.name,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) =>
      _$EventCategoryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EventCategoryToJson(this);

  static get instance {
    log('Initializing Firestore Collection Reference for EventCategory');
    try {
      return FirebaseFirestore.instance
          .collection('EventCategory')
          .withConverter<EventCategory>(
        fromFirestore: (snapshot, _) {
          log('Fetching EventCategory from Firestore: ${snapshot.id}');
          final data = snapshot.data();
          if (data != null) {
            log('EventCategory Data: $data');
            return EventCategory.fromJson({...data, 'id': snapshot.id});
          } else {
            log('No data found for EventCategory document ID: ${snapshot.id}');
            throw Exception('No data found in Firestore document');
          }
        },
        toFirestore: (eventCategory, _) {
          final json = _$EventCategoryToJson(eventCategory);
          log('Saving EventCategory to Firestore: $json');
          return json;
        },
      );
    } catch (e, stack) {
      log('Error initializing Firestore Collection Reference: $e\nStack Trace: $stack',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  CollectionReference<EventCategory> getReference() => instance;

  static EventCategory dummy() => EventCategory(name: '');

  @override
  String toString() {
    return 'EventCategory{id: $id, name: $name}';
  }

  EventCategory copyWith({
    required String? id,
    String? name,
  }) {
    log('Creating copy of EventCategory with id: ${id ?? this.id}');
    return EventCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
