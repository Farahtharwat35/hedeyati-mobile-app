import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/crud/sqflite_crud_service_class.dart';
import '../../database/firestore/crud.dart';
import '../../models/gift_category.dart';
import '../generic_bloc/generic_crud_bloc.dart';
import '../generic_bloc/generic_states.dart';
import 'gift_category_events.dart';
import 'gift_category_states.dart';

class GiftCategoryBloc extends ModelBloc<GiftCategory> {
  GiftCategoryBloc() : super(model: GiftCategory.dummy()) {
    _initializeStreams();
    on<LoadGiftCategoriesEventToLocalDatabase>(saveGiftCategoriesToLocalDatabase);
    on<GetGiftCategoryNameByIDFromLocalDatabaseEvent>(getGiftCategoryNameByIDFromLocalDatabase);
    on<GetAllGiftCategoriesEvent>(getGiftCategories);
  }

  late final Stream<List<GiftCategory>> _giftCategoryStream;

  void _initializeStreams() {
    _giftCategoryStream = giftCategoryCRUD.getSnapshotsWhere([]).map(
          (snapshot) => snapshot.docs.map((doc) => doc.data() as GiftCategory).toList(),
    );
  }

  Future<void> saveGiftCategoriesToLocalDatabase(LoadGiftCategoriesEventToLocalDatabase event, Emitter<ModelStates> emit) async{
    log('=========Saving Gift Categories to Local Database....=================');
    try {
      _giftCategoryStream.listen((giftCategories) async {
        await SqliteDatabaseCRUD.batchAlterModel(
            'GiftCategory', AlterType.insert,
            giftCategories.map((toElement) => toElement.toJson()).toList(), conflictAlgorithm: ConflictAlgorithm.replace);
      });
      log('=========Gift Categories saved to Local Database=================');
      emit(GiftCategoryToLocalDatabaseLoadedState());
    }
    catch (e) {
      log('Error saving giftCategories to local DB: $e');
    }

  }

  Future<Object?> getGiftCategoryNameByIDFromLocalDatabase(GetGiftCategoryNameByIDFromLocalDatabaseEvent event, Emitter<ModelStates> emit) async {
    log('=========Getting Gift Category Name by ID from Local Database....=================');
    try {
      final giftCategory = await SqliteDatabaseCRUD.getWhere('GiftCategory',event.id);
      log('=========Gift Category Name by ID from Local Database: ${giftCategory[0]['name']}=================');
      emit(GiftCategoryNameFromLocalDatabaseLoadedState());
      return giftCategory[0]['name'];
    }
    catch (e) {
      log('Error getting giftCategory name from local DB: $e');
    }
    return null;
  }

  Future<void> getGiftCategories(GetAllGiftCategoriesEvent event, Emitter<ModelStates> emit) async {
    emit((ModelLoadingState()));
    log('=========Getting Gift Categories....=================');
    try {
      final giftCategories = await SqliteDatabaseCRUD.getAll('GiftCategory');
      log('=========Gift Categories: $giftCategories=================');

      emit((ModelLoadedState(giftCategories.map((e) => GiftCategory.fromJson(e)).toList())));
    }
    catch (e) {
      log('Error getting giftCategories: $e');
    }
  }

  static GiftCategoryBloc get(context) => BlocProvider.of<GiftCategoryBloc>(context);

  Stream<List<GiftCategory>> get giftCategoryBlocStream => _giftCategoryStream;
}
