import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedeyati/helpers/id_generator.dart';
import 'package:hedeyati/models/user.dart' ;
import 'package:hedeyati/models/event.dart' ;
import 'package:hedeyati/models/event_category.dart';
import 'package:hedeyati/models/gift.dart' ;
import '../../helpers/query_arguments.dart';
import '../../models/gift_category.dart';
import '../../models/model.dart';
import '../../models/notification.dart' as Notification;

class CRUD<GenericModel extends Model> {
  GenericModel model;

  CRUD({required this.model});

  List<GenericModel> snapshotToModel(QuerySnapshot<Object?>? snapshot) {
    log('SnapshotToModel method started .......');
    List<GenericModel> models = snapshot?.docs
        .map((doc) => doc.data() as GenericModel)
        .whereType<GenericModel>()
        .toList() ??
        [];
    log('********** Models length: ${models.length} **********');
    return models;

  }

  Future<GenericModel> get(id) async {
    return await model
        .getReference()
        .doc(id)
        .get()
        .then((snapshot) => snapshot.data()! as GenericModel);
  }

  getReference() => model.getReference();

  Query<Model> getWhereQuery(List<Map<String, QueryArg>> where) {
    String queryDebugInfo = 'Starting query on collection: ${model.getReference().path}\n';
    dynamic query = model.getReference();
    for (var queryGroup in where) {
      queryGroup.forEach((field, arg) {
        queryDebugInfo += 'Condition: $field ${arg.argMap()} \n';
        query = Function.apply(query.where, [field], arg.argMap());
      });
      log('======= Query Executed: $queryDebugInfo');
    }
    return query;
  }

  Future<List<GenericModel>> getWhere(List<Map<String, QueryArg>> where) async {
    dynamic query = getWhereQuery(where);
    return snapshotToModel((await query.get()));
  }

  Stream<QuerySnapshot<Model>> getSnapshotsWhere(
      List<Map<String, QueryArg>> where) {
    dynamic query=getWhereQuery(where);
    return query.snapshots();
  }

  Future<void> add({required GenericModel model , bool uuID = true}) async {
    model.createdAt = DateTime.now().toIso8601String();
    uuID ? model.id = uuIDGenerator() : model.id = model.id;
    await model.getReference().doc(model.id).set(model);
  }

  Future<void> update(GenericModel model) {
    model.updatedAt = DateTime.now().toIso8601String();
    log('***********Updating model: ${model.toJson()}****************');
    return model.getReference().doc(model.id).update(model.toJson());
  }

  Future<void> delete(GenericModel model) {
    return model.getReference().doc(model.id).update({'isDeleted': true , 'deletedAt': DateTime.now().toIso8601String()});
  }
}

CRUD<Event> eventCRUD = CRUD<Event>(model: Event.dummy());
CRUD<User> userCRUD = CRUD<User>(model: User.dummy());
CRUD<Gift> giftCRUD = CRUD<Gift>(model: Gift.dummy());
CRUD<Notification.Notification> notificationCRUD = CRUD<Notification.Notification>(model: Notification.Notification.dummy());
CRUD<EventCategory> eventCategoryCRUD = CRUD<EventCategory>(model: EventCategory.dummy());
CRUD<GiftCategory> giftCategoryCRUD = CRUD<GiftCategory>(model: GiftCategory.dummy());
