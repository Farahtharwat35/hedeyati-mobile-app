class Friends {
  int userID;
  int friendID;

  Friends({
    required this.userID,
    required this.friendID,
  });

  factory Friends.fromJson(Map<String, dynamic> json) {
    return Friends(
      userID: json['userID'],
      friendID: json['friendID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'friendID': friendID,
    };
  }
}