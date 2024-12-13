// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gift _$GiftFromJson(Map<String, dynamic> json) => Gift(
      id: json['id'] as String?,
      firestoreUserID: json['firestoreUserID'] as String?,
      eventID: json['eventID'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String?,
      isPledged: json['isPledged'] as bool? ?? false,
      pledgedBy: (json['pledgedBy'] as num?)?.toInt(),
      pledgedDate: json['pledgedDate'] == null
          ? null
          : DateTime.parse(json['pledgedDate'] as String),
      price: (json['price'] as num).toDouble(),
      categoryID: json['categoryID'] as String,
      storesLocationRecommendation:
          json['storesLocationRecommendation'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    )
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..isDeleted = json['isDeleted'] as bool
      ..categoryName = json['categoryName'] as String?;

Map<String, dynamic> _$GiftToJson(Gift instance) => <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'name': instance.name,
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
      'categoryName': instance.categoryName,
    };
