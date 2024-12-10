// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      firestoreUserID: json['firestoreUserID'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      categoryID: (json['categoryID'] as num).toInt(),
      eventDate: DateTime.parse(json['eventDate'] as String),
      status: (json['status'] as num).toInt(),
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      image: json['image'] as String? ?? '',
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )
      ..id = json['id'] as String
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'firestoreUserID': instance.firestoreUserID,
      'image': instance.image,
      'name': instance.name,
      'description': instance.description,
      'categoryID': instance.categoryID,
      'eventDate': instance.eventDate.toIso8601String(),
      'status': instance.status,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
