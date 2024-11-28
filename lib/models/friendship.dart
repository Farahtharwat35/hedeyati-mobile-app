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

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'friendID': friendID,
      'friendshipStatus': friendshipStatus,
    };
  }
}
