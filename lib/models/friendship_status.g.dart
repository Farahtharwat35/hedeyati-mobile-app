// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendshipStatus _$FriendshipStatusFromJson(Map<String, dynamic> json) =>
    FriendshipStatus(
      status: json['status'] as String,
    )
      ..id = json['id'] as String
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$FriendshipStatusToJson(FriendshipStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'status': instance.status,
    };
