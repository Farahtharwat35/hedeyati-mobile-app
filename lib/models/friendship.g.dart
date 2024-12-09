// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friendship _$FriendshipFromJson(Map<String, dynamic> json) => Friendship(
      requesterID: json['requesterID'] as String,
      recieverID: json['recieverID'] as String,
      friendshipStatus: (json['friendshipStatus'] as num).toInt(),
    )..id = json['id'] as String;

Map<String, dynamic> _$FriendshipToJson(Friendship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterID': instance.requesterID,
      'recieverID': instance.recieverID,
      'friendshipStatus': instance.friendshipStatus,
    };
