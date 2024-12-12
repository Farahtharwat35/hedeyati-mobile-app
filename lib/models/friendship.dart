import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

part 'friendship.g.dart';

@JsonSerializable()
// Friendship Class
class Friendship extends Model {
  @override
  String? id;
  final String requesterID;
  final String recieverID;
  final int friendshipStatus;

  Friendship({
    this.id,
    required this.requesterID,
    required this.recieverID,
    required this.friendshipStatus,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) =>
      _$FriendshipFromJson(json);

  Map<String, dynamic> toJson() => _$FriendshipToJson(this);

   static get instance => FirebaseFirestore.instance.collection('Friendships').withConverter<Friendship>(
    fromFirestore: (snapshot, _) => Friendship.fromJson({...snapshot.data()! , 'id': snapshot.id}),
    toFirestore: (friendship, _) => _$FriendshipToJson(friendship),
  );

  @override
  CollectionReference<Friendship> getReference() => instance;


  static Stream<QuerySnapshot<Friendship>> getFriendsByUserId(String userId) {
    return instance.where('userID', isEqualTo: userId).snapshots();
  }

  static Friendship dummy() => Friendship(requesterID: '', recieverID: '', friendshipStatus: 0);

  Friendship copyWith({
    required String? id,
    String? requesterID,
    String? recieverID,
    int? friendshipStatus,
  }) {
    return Friendship(
      id: id ?? this.id,
      requesterID: requesterID ?? this.requesterID,
      recieverID: recieverID ?? this.recieverID,
      friendshipStatus: friendshipStatus ?? this.friendshipStatus,
    );
  }

  @override
  String toString() {
    return 'Friendship{id: $id, requesterID: $requesterID, recieverID: $recieverID, friendshipStatus: $friendshipStatus}';
  }
}
