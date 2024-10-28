class Gift {
  final String description;
  final String imageUrl;
  final String price;
  bool isPledged;

  Gift({
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isPledged = false,
  });
}