// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendshipStatus _$FriendshipStatusFromJson(Map<String, dynamic> json) =>
    FriendshipStatus(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$FriendshipStatusToJson(FriendshipStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
    };
