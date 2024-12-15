// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friendship _$FriendshipFromJson(Map<String, dynamic> json) => Friendship(
      id: json['id'] as String?,
      requesterID: json['requesterID'] as String,
      recieverID: json['recieverID'] as String,
      friendshipStatusID: $enumDecodeNullable(
              _$FriendshipStatusEnumMap, json['friendshipStatusID']) ??
          FriendshipStatus.pending,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
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

Map<String, dynamic> _$FriendshipToJson(Friendship instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'requesterID': instance.requesterID,
      'recieverID': instance.recieverID,
      'friendshipStatusID':
          _$FriendshipStatusEnumMap[instance.friendshipStatusID],
      'members': instance.members,
    };

const _$FriendshipStatusEnumMap = {
  FriendshipStatus.pending: 'pending',
  FriendshipStatus.accepted: 'accepted',
  FriendshipStatus.rejected: 'rejected',
  FriendshipStatus.blocked: 'blocked',
};
