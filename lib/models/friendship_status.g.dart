// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendshipStatus _$FriendshipStatusFromJson(Map<String, dynamic> json) =>
    FriendshipStatus(
      id: json['id'] as String?,
      status: json['status'] as String,
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

Map<String, dynamic> _$FriendshipStatusToJson(FriendshipStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'status': instance.status,
    };
