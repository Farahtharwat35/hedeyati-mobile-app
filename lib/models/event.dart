import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

part 'event.g.dart';

@JsonSerializable()
// Event Class
class Event extends Model {
  final String firestoreUserID;
  final String image;
  final String name;
  final String description;
  final int categoryID;
  final DateTime startDate;
  final DateTime endDate;
  final int status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? deletedAt;

  Event({
    required this.firestoreUserID,
    required this.name,
    required this.description,
    required this.categoryID,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdBy,
    DateTime? createdAt,
    this.image = '',
    this.deletedAt,
  }) : createdAt = createdAt ?? DateTime.now();


  // factory Event.fromJson(Map<String, dynamic> json) =>
  //     _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Events').withConverter<Event>(
    fromFirestore: (snapshot, _) => Event.fromJson({...snapshot.data()! , 'id': snapshot.id}),
    toFirestore: (event, _) => _$EventToJson(event),
  );

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing Event JSON: $json'); // Log the entire JSON first
      return _$EventFromJson(json);
    } catch (e, stack) {
      print('Error while parsing Event JSON: $e');
      print('Stack Trace: $stack');
      print('Problematic JSON: $json'); // Identify which JSON caused the problem
      rethrow; // Re-throw the error after logging
    }
  }


  @override
  CollectionReference<Event> getReference() => instance;

  static Event dummy() => Event(
      firestoreUserID: '',
      name: '',
      description: '',
      categoryID: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      status: 0,
      createdBy: '',
      createdAt: DateTime.now(),
    );
}
