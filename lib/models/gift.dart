import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

part 'gift.g.dart';

@JsonSerializable()
// Gift Class
class Gift extends Model{
  final int? id;
  final String firestoreID;
  final String firestoreUserID;
  final int userID;
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
    this.firestoreID = '',
    this.firestoreUserID = '',
    required this.userID,
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
    String? firestoreID,
    String? firestoreUserID,
    int? userID,
    String? description,
    String? photoUrl,
    bool? isPledged,
    int? pledgedBy,
    DateTime? pledgedDate,
    double? price,
    int? categoryID,
    String? storesLocationRecommendation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Gift(
      id: id ?? this.id,
      firestoreID: firestoreID ?? this.firestoreID,
      firestoreUserID: firestoreUserID ?? this.firestoreUserID,
      userID: userID ?? this.userID,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      isPledged: isPledged ?? this.isPledged,
      pledgedBy: pledgedBy ?? this.pledgedBy,
      pledgedDate: pledgedDate ?? this.pledgedDate,
      price: price ?? this.price,
      categoryID: categoryID ?? this.categoryID,
      storesLocationRecommendation:
      storesLocationRecommendation ?? this.storesLocationRecommendation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Future<void> addGiftToFirestore(Gift gift) async {
    await Gift.instance.add(gift);
  }

  static Future<void> updateGiftInFirestore(Gift gift) async {
    await Gift.instance.doc(gift.firestoreID).update(gift);
  }

  static Future<void> deleteGiftFromFirestore(Gift gift) async {
    await Gift.instance.doc(gift.firestoreID).delete();
  }

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);

  Map<String, dynamic> toJson() => _$GiftToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Gift').withConverter<Gift>(
    fromFirestore: (snapshot, _) => Gift.fromJson(snapshot.data()!),
    toFirestore: (gift, _) => _$GiftToJson(gift),
  );

  @override
  CollectionReference<Gift> getReference() => instance;
}