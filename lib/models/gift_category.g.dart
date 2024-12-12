// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftCategory _$GiftCategoryFromJson(Map<String, dynamic> json) => GiftCategory(
      id: json['id'] as String?,
      name: json['name'] as String,
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

Map<String, dynamic> _$GiftCategoryToJson(GiftCategory instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'name': instance.name,
    };
