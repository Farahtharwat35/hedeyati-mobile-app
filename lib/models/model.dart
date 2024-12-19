import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/timestampToDateTimeConverter.dart';

abstract class Model {
  // Map<String,dynamic>? getSortableAttributes();
  // Map<String,dynamic>? getFilterableAttributes();
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  bool isDeleted = false;
  Map<String, dynamic> toJson();
  CollectionReference<Model> getReference();
  static DateTime _fromTimestamp(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _toTimestamp(DateTime date) => Timestamp.fromDate(date);
}