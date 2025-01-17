import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'model.dart';
part 'gift.g.dart';

@JsonSerializable()
// Gift Class
class Gift extends Model {
  @override
  String? id;
  final String name;
  final String firestoreUserID;
  final String eventID;
  final String description;
  final String? photoUrl;
  final bool isPledged;
  final String? pledgedBy;
  final DateTime? pledgedDate;
  final double price;
  final String categoryID;

  Gift({
    this.id,
    required this.firestoreUserID,
    required this.eventID,
    required this.name,
    required this.description,
    this.photoUrl,
    this.isPledged = false,
    this.pledgedBy,
    this.pledgedDate,
    required this.price,
    required this.categoryID,
  }) ;

  Gift copyWith({
    required String? id,
    String? eventID,
    String? description,
    String? name,
    String? photoUrl,
    bool? isPledged,
    String? pledgedBy,
    DateTime? pledgedDate,
    double? price,
    String? categoryID,
  }) {
    return Gift(
      id: this.id,
      firestoreUserID: firestoreUserID,
      eventID: eventID ?? this.eventID,
      name: name ?? this.name,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      isPledged: isPledged ?? this.isPledged,
      pledgedBy: pledgedBy ?? this.pledgedBy,
      pledgedDate: pledgedDate ?? this.pledgedDate,
      price: price ?? this.price,
      categoryID: this.categoryID,
    ).. createdAt = createdAt
      .. updatedAt = updatedAt
      .. isDeleted = isDeleted;
  }

  factory Gift.fromJson(Map<String, dynamic> json) => _$GiftFromJson(json);

  @override
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
    name: 'Dummy Gift',
    description: 'Dummy gift description',
    price: 0.0,
    categoryID: 'dummy-category',
  );

  @override
  CollectionReference<Gift> getReference() => instance;

  @override
  String toString() {
    return 'Gift{id: $id, firestoreUserID: $firestoreUserID, eventID: $eventID, description: $description, photoUrl: $photoUrl, isPledged: $isPledged, pledgedBy: $pledgedBy, pledgedDate: $pledgedDate, price: $price, categoryID: $categoryID, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

}
