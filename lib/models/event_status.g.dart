// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventStatus _$EventStatusFromJson(Map<String, dynamic> json) => EventStatus(
      id: json['id'] as String?,
      status: json['status'] as String,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..deletedAt = json['deletedAt'] as String?
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$EventStatusToJson(EventStatus instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'status': instance.status,
    };
