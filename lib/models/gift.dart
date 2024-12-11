import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

part 'gift.g.dart';

@JsonSerializable()
// Gift Class
class Gift extends Model {
  final String firestoreUserID;
  final String eventID;
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
    this.firestoreUserID = '',
    required this.eventID,
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
    String? id,
    String? firestoreUserID,
    String? eventID,
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
      firestoreUserID: firestoreUserID ?? this.firestoreUserID,
      eventID: eventID ?? this.eventID,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      isPledged: isPledged ?? this.isPledged,
      pledgedBy: pledgedBy ?? this.pledgedBy,
      pledgedDate: pledgedDate ?? this.pledgedDate,
      price: price ?? this.price,
      categoryID: categoryID ?? this.categoryID,
      storesLocationRecommendation: storesLocationRecommendation ?? this.storesLocationRecommendation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);

  Map<String, dynamic> toJson() => _$GiftToJson(this);

  static get instance => FirebaseFirestore.instance.collection('Gift').withConverter<Gift>(
    fromFirestore: (snapshot, _) => Gift.fromJson({
      ...snapshot.data()!,
      'id': snapshot.id,
    }),
    toFirestore: (gift, _) => gift.toJson(),
  );

  static Gift dummy() => Gift(
    firestoreUserID: 'dummy-user',
    eventID: 'dummy-event',
    description: 'Dummy gift description',
    price: 0.0,
    categoryID: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  @override
  CollectionReference<Gift> getReference() => instance;
}
