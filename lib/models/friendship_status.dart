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
}
