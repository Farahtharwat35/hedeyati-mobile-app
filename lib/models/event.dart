import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
// Event Class
class Event {
  final int? id;
  final String name;
  final String? description;
  final int categoryID;
  final DateTime startDate;
  final DateTime? endDate;
  final int status;
  final int createdBy;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Event({
    this.id,
    required this.name,
    this.description,
    required this.categoryID,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.createdBy,
    DateTime? createdAt,
    this.deletedAt,
  }) : createdAt = createdAt ?? DateTime.now();


  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  static get instance => FirebaseFirestore.instance.collection('events').withConverter<Event>(
    fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
    toFirestore: (movie, _) => _$EventToJson(movie),
  );

  }
