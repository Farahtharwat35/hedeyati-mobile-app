
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hedeyati/models/model.dart';


part 'gift_category.g.dart';

@JsonSerializable()
class GiftCategory extends Model {
  @override
  String? id;
  final String name;

  GiftCategory({
    this.id,
    required this.name,
  });


  factory GiftCategory.fromJson(Map<String, dynamic> json) {
    log('Parsing GiftCategory JSON: $json');
    try {
      return _$GiftCategoryFromJson(json);
    } catch (e, stack) {
      log('Error while parsing GiftCategory JSON: $e\nStack Trace: $stack', error: e, stackTrace: stack);
      log('Problematic JSON: $json');
      rethrow;
    }
  }


  @override
  Map<String, dynamic> toJson() {
    final json = _$GiftCategoryToJson(this);
    log('Converting GiftCategory to JSON: $json');
    return json;
  }

  static get instance {
    log('Initializing Firestore Collection Reference for GiftCategory');
    try {
      return FirebaseFirestore.instance
          .collection('GiftCategory')
          .withConverter<GiftCategory>(
        fromFirestore: (snapshot, _) {
          log('Fetching GiftCategory from Firestore: ${snapshot.id}');
          final data = snapshot.data();
          if (data != null) {
            log('GiftCategory Data: $data');
            return GiftCategory.fromJson({...data, 'id': snapshot.id});
          } else {
            log('No data found for GiftCategory document ID: ${snapshot.id}');
            throw Exception('No data found in Firestore document');
          }
        },
        toFirestore: (giftCategory, _) {
          final json = _$GiftCategoryToJson(giftCategory);
          log('Saving GiftCategory to Firestore: $json');
          return json;
        },
      );
    } catch (e, stack) {
      log('Error initializing Firestore Collection Reference: $e\nStack Trace: $stack',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  CollectionReference<GiftCategory> getReference() => instance;

  static GiftCategory dummy() => GiftCategory(name: '');

  @override
  String toString() {
    return 'GiftCategory{id: $id, name: $name}';
  }

  GiftCategory copyWith({
    required String? id,
    String? name,
  }) {
    log('Creating copy of GiftCategory with id: ${id ?? this.id}');
    return GiftCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

}
