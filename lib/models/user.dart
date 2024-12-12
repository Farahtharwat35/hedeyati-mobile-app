import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';
part 'user.g.dart';

@JsonSerializable()
class User extends Model {
  @override
  String? id;
  String name;
  String email;
  String password;
  String avatar;
  String phone;
  bool isFriend;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatar,
    required this.phone,
    this.isFriend = false,
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

  static User dummy() => User(name: '', email: '', password: '', avatar: '', phone: '');

  User copyWith({
    required String? id,
    String? name,
    String? email,
    String? password,
    String? avatar,
    String? phone,
    bool? isFriend,
  }) {
    return User(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      isFriend: isFriend ?? this.isFriend,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password, avatar: $avatar, phone: $phone}';
  }
}
