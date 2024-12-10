import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

part 'event_status.g.dart';

@JsonSerializable()
// EventStatus Class
class EventStatus extends Model {
  final String status;

  EventStatus({
    required this.status,
  });

  factory EventStatus.fromJson(Map<String, dynamic> json) =>
      _$EventStatusFromJson(json);

  Map<String, dynamic> toJson() => _$EventStatusToJson(this);

  static get instance => FirebaseFirestore.instance.collection('EventStatus').withConverter<EventStatus>(
    fromFirestore: (snapshot, _) => EventStatus.fromJson({...snapshot.data()! , 'id': snapshot.id}),
    toFirestore: (eventStatus, _) => _$EventStatusToJson(eventStatus),
  );

  @override
  CollectionReference<EventStatus> getReference() => instance;

  static EventStatus dummy() => EventStatus(status: '');
}