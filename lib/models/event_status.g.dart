// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventStatus _$EventStatusFromJson(Map<String, dynamic> json) => EventStatus(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$EventStatusToJson(EventStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
    };
