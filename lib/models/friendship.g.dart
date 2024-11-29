// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friendship _$FriendshipFromJson(Map<String, dynamic> json) => Friendship(
      userID: (json['userID'] as num).toInt(),
      friendID: (json['friendID'] as num).toInt(),
      friendshipStatus: (json['friendshipStatus'] as num).toInt(),
    );

Map<String, dynamic> _$FriendshipToJson(Friendship instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'friendID': instance.friendID,
      'friendshipStatus': instance.friendshipStatus,
    };
