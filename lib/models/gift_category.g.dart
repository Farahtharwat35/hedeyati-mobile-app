// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftCategory _$GiftCategoryFromJson(Map<String, dynamic> json) => GiftCategory(
      id: json['id'] as String?,
      name: json['name'] as String,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..deletedAt = json['deletedAt'] as String?
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$GiftCategoryToJson(GiftCategory instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'name': instance.name,
    };
