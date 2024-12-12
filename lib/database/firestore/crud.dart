import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedeyati/models/user.dart' ;
import 'package:hedeyati/models/event.dart' ;
import 'package:hedeyati/models/event_category.dart';
import 'package:hedeyati/models/friendship.dart' ;
import 'package:hedeyati/models/gift.dart' ;
import '../../helpers/query_arguments.dart';
import '../../models/gift_category.dart';
import '../../models/model.dart';

class CRUD<GenericModel extends Model> {
  GenericModel model;

  CRUD({required this.model});

  List<GenericModel> snapshotToModel(QuerySnapshot<Object?>? snapshot) {
    return snapshot?.docs
        .map((doc) => doc.data() as GenericModel)
        .whereType<GenericModel>()
        .toList() ??
        [];
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
    dynamic query = model.getReference();
    for (var queryGroup in where) {
      queryGroup.forEach((field, arg) {
        query = Function.apply(query.where, [field], arg.argMap());
      });
    }
    return query;
  }

  Future<List<GenericModel>> getWhere(List<Map<String, QueryArg>> where) async {
    dynamic query = getWhereQuery(where);
    return snapshotToModel((await query.get()));
  }

  Stream<QuerySnapshot<Model>> getSnapshotsWhere(
      List<Map<String, QueryArg>> where) {
    dynamic query =getWhereQuery(where);
    return query.snapshots();
  }

  Future<void> add(GenericModel model) async {
    model.createdAt = DateTime.now();
    await model.getReference().add(model);
  }

  Future<void> update(GenericModel model) {
    model.updatedAt = DateTime.now();
    return model.getReference().doc(model.id).update(model.toJson());
  }

  Future<void> delete(GenericModel model) {
    return model.getReference().doc(model.id).update({'isDeleted': true , 'deletedAt': DateTime.now()});
  }
}

CRUD<Event> eventCRUD = CRUD<Event>(model: Event.dummy());
CRUD<User> userCRUD = CRUD<User>(model: User.dummy());
CRUD<Friendship> friendshipCRUD = CRUD<Friendship>(model: Friendship.dummy());
CRUD<Gift> giftCRUD = CRUD<Gift>(model: Gift.dummy());
CRUD<EventCategory> eventCategoryCRUD = CRUD<EventCategory>(model: EventCategory.dummy());
CRUD<GiftCategory> giftCategoryCRUD = CRUD<GiftCategory>(model: GiftCategory.dummy());
