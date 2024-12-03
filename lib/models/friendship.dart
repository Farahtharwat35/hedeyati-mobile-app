import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

part 'friendship.g.dart';

@JsonSerializable()
// Friendship Class
class Friendship extends Model {
  final int userID;
  final int friendID;
  final int friendshipStatus;

  Friendship({
    required this.userID,
    required this.friendID,
    required this.friendshipStatus,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) =>
      _$FriendshipFromJson(json);

  Map<String, dynamic> toJson() => _$FriendshipToJson(this);

   static get instance => FirebaseFirestore.instance.collection('Friendships').withConverter<Friendship>(
    fromFirestore: (snapshot, _) => Friendship.fromJson(snapshot.data()!),
    toFirestore: (friendship, _) => _$FriendshipToJson(friendship),
  );

  @override
  CollectionReference<Friendship> getReference() => instance;

  // Get friends by user ID and return a stream with Friendship converter
  static Stream<QuerySnapshot<Friendship>> getFriendsByUserId(int userId) {
    return instance.where('userID', isEqualTo: userId).snapshots();
  }

}
