import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

part 'event_status.g.dart';

@JsonSerializable()
// EventStatus Class
class EventStatus extends Model {
  @override
  String? id;
  final String status;

  EventStatus({
    this.id,
    required this.status,
  });

  factory EventStatus.fromJson(Map<String, dynamic> json) =>
      _$EventStatusFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EventStatusToJson(this);

  static get instance {
    log('Initializing Firestore Collection Reference for EventStatus');
    try {
      return FirebaseFirestore.instance.collection('EventStatus').withConverter<EventStatus>(
        fromFirestore: (snapshot, _) {
          log('Fetching EventStatus from Firestore: ${snapshot.id}');
          final data = snapshot.data();
          if (data != null) {
            log('EventStatus Data: $data');
            return EventStatus.fromJson({...data, 'id': snapshot.id});
          } else {
            log('No data found for EventStatus document ID: ${snapshot.id}');
            throw Exception('No data found in Firestore document');
          }
        },
        toFirestore: (eventStatus, _) {
          final json = _$EventStatusToJson(eventStatus);
          log('Saving EventStatus to Firestore: $json');
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
  CollectionReference<EventStatus> getReference() => instance;

  static EventStatus dummy() => EventStatus(status: '');

  @override
  String toString() {
    return 'EventStatus{id: $id, status: $status}';
  }

  EventStatus copyWith({
    required String? id,
    String? status,
  }) {
    log('Creating copy of EventStatus with id: ${id ?? this.id}');
    return EventStatus(
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }
}
