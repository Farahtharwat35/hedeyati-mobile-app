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
  }

  late final Stream<List<GiftCategory>> _giftCategoryStream;

  void _initializeStreams() {
    _giftCategoryStream = giftCategoryCRUD.getSnapshotsWhere([]).map(
          (snapshot) => snapshot.docs.map((doc) => doc.data() as GiftCategory).toList(),
    );
  }

  Future<void> saveGiftCategoriesToLocalDatabase(LoadGiftCategoriesEventToLocalDatabase event, Emitter<ModelStates> emit) async{
    print('=========Saving Gift Categories to Local Database....=================');
    try {
      _giftCategoryStream.listen((giftCategories) async {
        await SqliteDatabaseCRUD.batchAlterModel(
            'GiftCategory', AlterType.insert,
            giftCategories.map((toElement) => toElement.toJson()).toList(), conflictAlgorithm: ConflictAlgorithm.replace);
      });
      print('=========Gift Categories saved to Local Database=================');
      emit(GiftCategoryToLocalDatabaseLoadedState());
    }
    catch (e) {
      print('Error saving giftCategories to local DB: $e');
    }

  }

  static GiftCategoryBloc get(context) => BlocProvider.of<GiftCategoryBloc>(context);

  Stream<List<GiftCategory>> get giftCategoryBlocStream => _giftCategoryStream;
}
