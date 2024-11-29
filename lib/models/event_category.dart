import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_category.g.dart';

@JsonSerializable()
// EventCategory Class
class EventCategory {
  final int? id;
  final String name;

  EventCategory({
    this.id,
    required this.name,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) =>
      _$EventCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$EventCategoryToJson(this);


  static get instance => FirebaseFirestore.instance.collection('EventCategory').withConverter<EventCategory>(
    fromFirestore: (snapshot, _) => EventCategory.fromJson(snapshot.data()!),
    toFirestore: (eventCategory, _) => _$EventCategoryToJson(eventCategory),
  );


}