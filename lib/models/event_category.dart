import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

part 'event_category.g.dart';

@JsonSerializable()
// EventCategory Class
class EventCategory extends Model {
  final String name;

  EventCategory({
    required this.name,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) =>
      _$EventCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$EventCategoryToJson(this);


  static get instance => FirebaseFirestore.instance.collection('EventCategory').withConverter<EventCategory>(
    fromFirestore: (snapshot, _) => EventCategory.fromJson({...snapshot.data()! , 'id': snapshot.id}),
    toFirestore: (eventCategory, _) => _$EventCategoryToJson(eventCategory),
  );

  @override
  CollectionReference<EventCategory> getReference() => instance;

  static EventCategory dummy() =>  EventCategory(name: '');

}