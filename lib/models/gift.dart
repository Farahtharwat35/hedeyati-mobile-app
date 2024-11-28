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
}