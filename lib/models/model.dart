import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Model {
  // Map<String,dynamic>? getSortableAttributes();
  Map<String, dynamic> toJson();
  CollectionReference<Model> getReference();
  // List<String> getSearcableAttributes();
}