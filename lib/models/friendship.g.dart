// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friendship _$FriendshipFromJson(Map<String, dynamic> json) => Friendship(
      id: json['id'] as String?,
      requesterID: json['requesterID'] as String,
      recieverID: json['recieverID'] as String,
      friendshipStatusID: (json['friendshipStatusID'] as num?)?.toInt(),
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..deletedAt = json['deletedAt'] as String?
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$FriendshipToJson(Friendship instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'requesterID': instance.requesterID,
      'recieverID': instance.recieverID,
      'friendshipStatusID': instance.friendshipStatusID,
      'members': instance.members,
    };
