class Gift {
  final int id;
  String description;

  String imageUrl;
  String price;
  bool isPledged;

  Gift({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isPledged = false,
  });
  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      isPledged: json['isPledged'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isPledged': isPledged,
    };
  }
}
