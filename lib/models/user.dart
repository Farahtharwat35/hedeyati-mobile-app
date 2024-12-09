import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';
part 'user.g.dart';

@JsonSerializable()
class User extends Model {
  String name;
  String email;
  String password;
  String avatar;
  String phone;
  bool isFriend;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.avatar,
    required this.phone,
    this.isFriend = false,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Users').withConverter<User>(
    fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
    toFirestore: (user, _) => _$UserToJson(user),
  );

  @override
  CollectionReference<User> getReference() => instance;

  static User dummy() => User(name: '', email: '', password: '', avatar: '', phone: '');
}
