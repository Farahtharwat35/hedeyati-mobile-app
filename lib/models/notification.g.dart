// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      title: json['title'] as String,
      body: json['body'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      initiatorID: json['initiatorID'] as String,
      receiverID: json['receiverID'] as String,
    )
      ..id = json['id'] as String?
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..deletedAt = json['deletedAt'] as String?
      ..isDeleted = json['isDeleted'] as bool
      ..isRead = json['isRead'] as bool;

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'isDeleted': instance.isDeleted,
      'initiatorID': instance.initiatorID,
      'receiverID': instance.receiverID,
      'title': instance.title,
      'body': instance.body,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'isRead': instance.isRead,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.friendRequest: 'friendRequest',
  NotificationType.other: 'other',
};
