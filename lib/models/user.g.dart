// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      username: json['username'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      phoneNumber: json['phoneNumber'] as String,
    )
      ..createdAt = json['createdAt'] as String?
      ..updatedAt = json['updatedAt'] as String?
      ..deletedAt = json['deletedAt'] as String?
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'deletedAt': instance.deletedAt,
      'isDeleted': instance.isDeleted,
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'avatar': instance.avatar,
      'phoneNumber': instance.phoneNumber,
    };
