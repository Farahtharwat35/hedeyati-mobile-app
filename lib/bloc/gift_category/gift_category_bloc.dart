
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/firestore/crud.dart';
import '../../models/gift_category.dart';
import '../generic_bloc/generic_crud_bloc.dart';

class GiftCategoryBloc extends ModelBloc<GiftCategory> {
  GiftCategoryBloc() : super(model: GiftCategory.dummy()) {
    _initializeStreams();
  }

  late final Stream<List<GiftCategory>> _giftCategoryStream;

  void _initializeStreams() {
    _giftCategoryStream = giftCategoryCRUD.getSnapshotsWhere([]).map(
          (snapshot) => snapshot.docs.map((doc) => doc.data() as GiftCategory).toList(),
    );
  }

  static GiftCategoryBloc get(context) => BlocProvider.of<GiftCategoryBloc>(context);

  Stream<List<GiftCategory>> get giftCategoryBlocStream => _giftCategoryStream;
}
