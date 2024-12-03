// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hedeyati/helpers/query_arguments.dart';
// import 'package:hedeyati/models/CRUDFactory.dart';
// import 'package:hedeyati/models/generic_bloc_event.dart';
// import 'package:hedeyati/models/model.dart';
// import 'package:hedeyati/shared/generic_cubit/states.dart';
// import 'package:hedeyati/models/event_category.dart';
// import '../utils/helpers.dart';
//
// class ModelCubit<GenericModel extends Model> extends Cubit<ModelStates> {
//   GenericModel model;
//   late CRUDFactory _CRUD;
//
//   ModelCubit({required this.model}) : super(ModelInitState()) {
//     _CRUD = CRUDFactory<GenericModel>(model: model);
//   }
//
//   static ModelCubit get(context) => BlocProvider.of(context);
//
//   void add(Model model) async {
//     emit(ModelLoadingState());
//     try {
//       await _CRUD.add(model);
//       emit(ModelAddedState());
//     } catch (e) {
//       emit(ModelErrorState());
//     }
//   }
//
//   void getWhere(List<Map<String, QueryArg>>  where) async {
//     emit(ModelLoadingState());
//     try {
//       List<Model> models = (await _CRUD.getWhere(where));
//       emit(ModelChangeState(models));
//     } catch (e) {
//       emit(ModelErrorState());
//     }
//   }
//
//   void update(Model model) async {
//     emit(ModelLoadingState());
//     try {
//       await _CRUD.update(model);
//       emit(ModelUpdatedState(model));
//     } catch (e) {
//       emit(ModelErrorState());
//     }
//   }
//
//   void delete(Model model) async {
//     emit(ModelLoadingState());
//     try {
//       await _CRUD.delete(model);
//       emit(ModelDeletedState(model));
//     } catch (e) {
//       emit(ModelErrorState());
//     }
//   }
// }
//
// class EventCubit extends ModelCubit<Event> {
//   EventCubit({required super.model});
//   static EventCubit get(context) => BlocProvider.of(context);
// }
//
// class CategoryCubit extends ModelCubit<EventCategory> {
//   CategoryCubit({required super.model});
//   static CategoryCubit get(context) => BlocProvider.of(context);
//
// }
