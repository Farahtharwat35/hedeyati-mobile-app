import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gift.g.dart';

@JsonSerializable()
// Gift Class
class Gift {
  final int? id;
  final String description;
  final String? photoUrl;
  final bool isPledged;
  final int? pledgedBy;
  final DateTime? pledgedDate;
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
    this.pledgedDate,
    required this.price,
    required this.categoryID,
    this.storesLocationRecommendation,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

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

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);

  Map<String, dynamic> toJson() => _$GiftToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Gift').withConverter<Gift>(
    fromFirestore: (snapshot, _) => Gift.fromJson(snapshot.data()!),
    toFirestore: (gift, _) => _$GiftToJson(gift),
  );
}