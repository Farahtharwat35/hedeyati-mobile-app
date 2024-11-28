// FriendshipStatus Class
class FriendshipStatus {
  final int? id;
  final String status;

  FriendshipStatus({
    this.id,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
    };
  }
}
