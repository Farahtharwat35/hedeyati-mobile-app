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
      categoryID: (json['categoryID'] as num).toInt(),
      eventDate: DateTime.parse(json['eventDate'] as String),
      status: (json['status'] as num).toInt(),
      image: json['image'] as String,
    )
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

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'firestoreUserID': instance.firestoreUserID,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'categoryID': instance.categoryID,
      'eventDate': instance.eventDate.toIso8601String(),
      'status': instance.status,
    };
