// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventStatus _$EventStatusFromJson(Map<String, dynamic> json) => EventStatus(
      status: json['status'] as String,
    )
      ..id = json['id'] as String?
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$EventStatusToJson(EventStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'status': instance.status,
    };
