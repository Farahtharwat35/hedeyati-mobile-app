

// User Class
class User {
  final int? id;
  final String name;
  final String email;
  final String phoneNumber;
  final bool isDeleted;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'is_deleted': isDeleted ? 1 : 0,
    };
  }
}