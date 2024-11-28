class Gift {
  String description;
  String imageUrl;
  String price;
  bool isPledged;

  Gift({
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isPledged = false,
  });
  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      isPledged: json['isPledged'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isPledged': isPledged,
    };
  }
}
