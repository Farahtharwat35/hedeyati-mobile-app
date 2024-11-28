// Gift Class
class Gift {
  final int? id;
  final String description;
  final String? photoUrl;
  final bool isPledged;
  final int? pledgedBy;
  final DateTime? pledgeDate;
  final double price;
  final int categoryID;
  final String? storesLocationRecommendation;
  final DateTime createdAt;
  final DateTime updatedAt;

  Gift({
    this.id,
    required this.description,
    this.photoUrl,
    this.isPledged = false,
    this.pledgedBy,
    this.pledgeDate,
    required this.price,
    required this.categoryID,
    this.storesLocationRecommendation,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'photo_url': photoUrl,
      'is_pledged': isPledged ? 1 : 0,
      'pledged_by': pledgedBy,
      'pledge_date': pledgeDate?.toIso8601String(),
      'price': price,
      'categoryID': categoryID,
      'stores_location_recommendation': storesLocationRecommendation,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Gift copyWith({
    int? id,
    String? description,
    String? photoUrl,
    double? price,
    bool? isPledged,
    int? categoryID,
  }) {
    return Gift(
      id: id ?? this.id,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      price: price ?? this.price,
      isPledged: isPledged ?? this.isPledged,
      categoryID: categoryID ?? this.categoryID,
    );
  }
}