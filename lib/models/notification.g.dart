// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      title: json['title'] as String,
      body: json['body'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
    )
      ..id = json['id'] as String?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String)
      ..updatedAt = json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'title': instance.title,
      'body': instance.body,
      'type': _$NotificationTypeEnumMap[instance.type]!,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.friendRequest: 'friendRequest',
  NotificationType.other: 'other',
};
