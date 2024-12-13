import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';

import '../helpers/timestampToDateTimeConverter.dart';

part 'friendship_status.g.dart';

@JsonSerializable()
// FriendshipStatus Class
class FriendshipStatus extends Model {
  final String status;

  FriendshipStatus({
    @override
    String? id,
    required this.status,
  });

  factory FriendshipStatus.fromJson(Map<String, dynamic> json) =>
      _$FriendshipStatusFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FriendshipStatusToJson(this);

  static get instance => FirebaseFirestore.instance.collection('FriendshipStatus').withConverter<FriendshipStatus>(
    fromFirestore: (snapshot, _) => FriendshipStatus.fromJson({...snapshot.data()! , 'id': snapshot.id}),
    toFirestore: (friendshipStatus, _) => _$FriendshipStatusToJson(friendshipStatus),
  );

  @override
  CollectionReference<FriendshipStatus> getReference() => instance;

  static FriendshipStatus dummy() => FriendshipStatus(status: '');

  @override
  String toString() {
    return 'FriendshipStatus{id: $id, status: $status}';
  }

  FriendshipStatus copyWith({
    required String? id,
    String? status,
  }) {
    return FriendshipStatus(
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }
}
