import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';
part 'user.g.dart';

@JsonSerializable()
class User extends Model {
  @override
  String? id;
  String username;
  String email;
  String? avatar;

  User({
    this.id,
    required this.username,
    required this.email,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Users').withConverter<User>(
    fromFirestore: (snapshot, _) => User.fromJson({...snapshot.data()! , 'id': snapshot.id}),
    toFirestore: (user, _) => _$UserToJson(user),
  );

  @override
  CollectionReference<User> getReference() => instance;

  static User dummy() => User(username: '', email: '', avatar: '');

  User copyWith({
    required String? id,
    String? name,
    String? email,
    String? password,
    String? avatar,
    String? phoneNumber,
  }) {
    return User(
      id: this.id,
      username: name ?? username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, avatar: $avatar}';
  }
}
