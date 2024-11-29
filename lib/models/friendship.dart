import 'package:json_annotation/json_annotation.dart';

part 'friendship.g.dart';

@JsonSerializable()
// Friendship Class
class Friendship {
  final int userID;
  final int friendID;
  final int friendshipStatus;

  Friendship({
    required this.userID,
    required this.friendID,
    required this.friendshipStatus,
  });
}
