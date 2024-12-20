// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String?,
      firestoreUserID: json['firestoreUserID'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      categoryID: json['categoryID'] as String,
      eventDate: json['eventDate'] as String,
      image: json['image'] as String,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..deletedAt = json['deletedAt'] as String?
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'firestoreUserID': instance.firestoreUserID,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'categoryID': instance.categoryID,
      'eventDate': instance.eventDate,
    };
