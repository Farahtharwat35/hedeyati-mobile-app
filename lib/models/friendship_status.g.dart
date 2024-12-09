// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendshipStatus _$FriendshipStatusFromJson(Map<String, dynamic> json) =>
    FriendshipStatus(
      status: json['status'] as String,
    )..id = json['id'] as String;

Map<String, dynamic> _$FriendshipStatusToJson(FriendshipStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
    };
