import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

part 'event.g.dart';

@JsonSerializable()
// Event Class
class Event extends Model {
  final int? id;
  final String firestoreID;
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
    this.id,
    required this.firestoreID,
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


  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Events').withConverter<Event>(
    fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
    toFirestore: (event, _) => _$EventToJson(event),
  );

  @override
  CollectionReference<Event> getReference() => instance;

  static Future<dynamic> addEvent(Event event) async {
    await instance.add(event);
  }

  static Future<dynamic> updateEvent(String id, Event event) async {
    await instance.doc(id).update(event.toJson());
  }

  static Future<dynamic> deleteEvent(String id) async {
    await instance.doc(id).delete();
  }

  static Future getFriendsEvents(userId) async {
    return instance.where('createdBy', isNotEqualTo: userId).get();
  }

  static Future getMyEvents(userId) async {
    print("----------------------ENTERED---------------");
    return instance.where('createdBy', isEqualTo: userId).get();
  }
}
