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
  final String title;
  final String body;
  final NotificationType type;

  Notification({required this.title, required this.body, required this.type});

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Notifications').withConverter<Notification>(
    fromFirestore: (snapshot, _) => Notification.fromJson({...snapshot.data()! , 'id': snapshot.id}),
    toFirestore: (notification, _) => _$NotificationToJson(notification),
  );

  @override
  CollectionReference<Notification> getReference() => instance;

  static Notification dummy() => Notification(title: '', body: '', type: NotificationType.other);

  Notification copyWith({
    required String? id,
    String? title,
    String? body,
    NotificationType? type,
  }) {
    return Notification(
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'Notification{id: $id, title: $title, body: $body, type: $type}';
  }

}