class User {
  final int id;
  String name;
  String email;
  String password;
  String avatar;
  String phone;
  bool isFriend;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatar,
    required this.phone,
    this.isFriend = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      avatar: json['avatar'],
      phone: json['phone'],
      isFriend: json['isFriend'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatar': avatar,
      'phone': phone,
      'isFriend': isFriend,
    };
  }
}
