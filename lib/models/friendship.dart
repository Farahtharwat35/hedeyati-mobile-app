import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

import '../helpers/timestampToDateTimeConverter.dart';

part 'friendship.g.dart';


enum FriendshipStatus {
  pending,
  accepted,
  rejected,
  blocked,
}

@JsonSerializable()
// Friendship Class
class Friendship extends Model {
  @override
  String? id;
  final String requesterID;
  final String recieverID;
  FriendshipStatus? friendshipStatusID;
  // This was created as firestore does not support OR/And queries
  final List<String> members;

  Friendship({
    this.id,
    required this.requesterID,
    required this.recieverID,
    this.friendshipStatusID = FriendshipStatus.pending,
    required this.members,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) =>
      _$FriendshipFromJson(json);

  @override
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

  static Friendship dummy() => Friendship(requesterID: '', recieverID: '', friendshipStatusID: FriendshipStatus.pending , members: []);

  Friendship copyWith({
    required String? id,
    String? requesterID,
    String? recieverID,
    String? friendshipStatus,
  }) {
    return Friendship(
      id: id ?? this.id,
      requesterID: requesterID ?? this.requesterID,
      recieverID: recieverID ?? this.recieverID,
      members: members,
      friendshipStatusID: friendshipStatusID,
    );
  }

  @override
  String toString() {
    return 'Friendship{id: $id, requesterID: $requesterID, recieverID: $recieverID, friendshipStatus: $friendshipStatusID}';
  }
}
