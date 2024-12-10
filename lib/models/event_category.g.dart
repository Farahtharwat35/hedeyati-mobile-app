// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventCategory _$EventCategoryFromJson(Map<String, dynamic> json) =>
    EventCategory(
      name: json['name'] as String,
    )
      ..id = json['id'] as String
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$EventCategoryToJson(EventCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'name': instance.name,
    };
