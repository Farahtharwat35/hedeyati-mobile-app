// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      avatar: json['avatar'] as String,
      phone: json['phone'] as String,
      isFriend: json['isFriend'] as bool? ?? false,
    )
      ..id = json['id'] as String
      ..isDeleted = json['isDeleted'] as bool;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'isFriend': instance.isFriend,
    };
