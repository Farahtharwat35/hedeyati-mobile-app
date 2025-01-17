import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

import '../shared/friendship_status_enum.dart';


part 'friendship.g.dart';


@JsonSerializable()
// Friendship Class
class Friendship extends Model {
  @override
  String? id;
  final String requesterID;
  final String recieverID;
  int? friendshipStatusID;
  // This was created as firestore does not support OR/And queries
  final List<String> members;

  Friendship({
    this.id,
    required this.requesterID,
    required this.recieverID,
    int? friendshipStatusID,
    required this.members,
  }):friendshipStatusID = friendshipStatusID ?? FriendshipStatus.pending.index;

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

  static Friendship dummy() => Friendship(requesterID: '', recieverID: '', friendshipStatusID: FriendshipStatus.pending.index , members: []);

  Friendship copyWith({
    required String? id,
    String? requesterID,
    String? recieverID,
    int? friendshipStatusID,
    bool isDeleted = false,
    String? deletedAt,
  }) {
    try {
      log('***********Copying Friendship***********');
      return Friendship(
        id: id ?? this.id,
        requesterID: requesterID ?? this.requesterID,
        recieverID: recieverID ?? this.recieverID,
        friendshipStatusID: friendshipStatusID ?? this.friendshipStatusID,
        members: members,
      ).. createdAt = createdAt
       .. updatedAt = updatedAt
       .. deletedAt = deletedAt ?? this.deletedAt
       .. isDeleted = isDeleted;
    } catch (e) {
      log('***********Failed to copy Friendship: $e***********');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'Friendship{id: $id, requesterID: $requesterID, recieverID: $recieverID, friendshipStatus: $friendshipStatusID}';
  }
}
