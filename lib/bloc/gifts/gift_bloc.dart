import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/gift.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../../models/event.dart';
import '../generic_bloc/generic_crud_bloc.dart';

class GiftBloc extends ModelBloc<Gift> {
  GiftBloc({required Event event}) : super(model: Gift.dummy()) {
    _initializeStreams(event);
  }

  late final Stream<List<Gift>> giftsStream;

  void _initializeStreams(Event event) {
    giftsStream = giftCRUD.getSnapshotsWhere([
      {'eventID': QueryArg(isEqualTo: event.id)},
    ]).map((snapshot) => snapshot.docs.map((doc) => doc.data() as Gift).toList());
  }

  static GiftBloc get(context) => BlocProvider.of(context);

}