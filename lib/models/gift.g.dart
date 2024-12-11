// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gift _$GiftFromJson(Map<String, dynamic> json) => Gift(
      firestoreUserID: json['firestoreUserID'] as String? ?? '',
      eventID: json['eventID'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String?,
      isPledged: json['isPledged'] as bool? ?? false,
      pledgedBy: (json['pledgedBy'] as num?)?.toInt(),
      pledgedDate: json['pledgedDate'] == null
          ? null
          : DateTime.parse(json['pledgedDate'] as String),
      price: (json['price'] as num).toDouble(),
      categoryID: (json['categoryID'] as num).toInt(),
      storesLocationRecommendation:
          json['storesLocationRecommendation'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    )
      ..id = json['id'] as String
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$GiftToJson(Gift instance) => <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'firestoreUserID': instance.firestoreUserID,
      'eventID': instance.eventID,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'isPledged': instance.isPledged,
      'pledgedBy': instance.pledgedBy,
      'pledgedDate': instance.pledgedDate?.toIso8601String(),
      'price': instance.price,
      'categoryID': instance.categoryID,
      'storesLocationRecommendation': instance.storesLocationRecommendation,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
