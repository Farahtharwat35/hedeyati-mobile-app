import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friendship_status.g.dart';

@JsonSerializable()
// FriendshipStatus Class
class FriendshipStatus {
  final int? id;
  final String status;

  FriendshipStatus({
    this.id,
    required this.status,
  });

  factory FriendshipStatus.fromJson(Map<String, dynamic> json) =>
      _$FriendshipStatusFromJson(json);

  Map<String, dynamic> toJson() => _$FriendshipStatusToJson(this);

  static get instance => FirebaseFirestore.instance.collection('FriendshipStatus').withConverter<FriendshipStatus>(
    fromFirestore: (snapshot, _) => FriendshipStatus.fromJson(snapshot.data()!),
    toFirestore: (friendshipStatus, _) => _$FriendshipStatusToJson(friendshipStatus),
  );
}
