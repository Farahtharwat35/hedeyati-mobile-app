// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../helpers/query_arguments.dart';
// import '../../models/model.dart';
//
//
// // THIS CLASS SERVES AS A DYNAMIC CRUD OPERATIONS CLASS FOR FIRESTORE //
//
// // CRUDFactory class is a generic class that takes a Model type as a parameter //
// import '../../models/generic_bloc_event.dart';
// import "package:hedeyati/models/friendship.dart";
// import 'package:hedeyati/models/gift.dart';
// import 'package:hedeyati/models/user.dart';
// // import 'package:hedeyati/shared/utils/helpers.dart';
//
//
// class CRUDFactory<GenericModel extends Model> {
//   GenericModel model;
//
//   CRUDFactory({required this.model});
//
//   Future<GenericModel> get(id) async {
//     return await model
//         .getReference()
//         .doc(id)
//         .get()
//         .then((snapshot) => snapshot.data()! as GenericModel);
//   }
//
//   CollectionReference<Model> getReference() => model.getReference();
//
//   Future<List<GenericModel>> getWhere(List<Map<String, QueryArg>> where) async {
//     dynamic query = model.getReference();
//     for (var queryGroup in where) {
//       queryGroup.forEach((field, arg) {
//         query = Function.apply(query.where, [field], arg.argMap());
//       });
//     }
//     return await query.get().then((snapshot) => snapshot.docs).then(
//             (docs) => docs.map((e) => e.data()).toList() as List<GenericModel>);
//   }
//
//   Future<void> add(GenericModel model) async {
//     await model.getReference().add(model);
//   }
//
//   Future<void> update(GenericModel model) {
//     return model.getReference().doc(model.id).update(model.toJson());
//   }
//
//   Future<void> delete(GenericModel model) {
//     return model.getReference().doc(model.id).delete();
//   }
// }
//
// CRUDFactory<User> userCRUD = CRUDFactory<User>(model: User.dummy());
// CRUDFactory<Event> eventCRUD = CRUDFactory<Event>(model: Event.dummy());
// CRUDFactory<Friendship> friendshipCRUD = CRUDFactory<Friendship>(model: Friendship.dummy());
// CRUDFactory<Gift> giftCRUD = CRUDFactory<Gift>(model: GiftModel.dummy());