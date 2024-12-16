import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

part 'notification.g.dart';

enum NotificationType {
  friendRequest,
  other,
}


@JsonSerializable()
class Notification extends Model {
  final String initiatorID;
  final String receiverID;
  final String title;
  final String body;
  final NotificationType type;
  bool isRead = false;

  Notification({required this.title, required this.body, required this.type, required this.initiatorID, required this.receiverID});

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Notifications').withConverter<Notification>(
    fromFirestore: (snapshot, _) => Notification.fromJson({...snapshot.data()! , 'id': snapshot.id}),
    toFirestore: (notification, _) => _$NotificationToJson(notification),
  );

  Notification copyWith({required bool isRead}) {
    return Notification(
      title: title,
      body: body,
      type: type,
      initiatorID: initiatorID,
      receiverID: receiverID,
    )..isRead = isRead;
  }


  @override
  CollectionReference<Notification> getReference() => instance;

  static Notification dummy() => Notification(title: '', body: '', type: NotificationType.other , initiatorID: '', receiverID: '');


  @override
  String toString() {
    return 'Notification{id: $id, title: $title, body: $body, type: $type}';
  }

}