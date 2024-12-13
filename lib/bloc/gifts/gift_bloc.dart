import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/gift.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../generic_bloc/generic_crud_bloc.dart';

class GiftBloc extends ModelBloc<Gift> {
  GiftBloc({String? eventID}) : super(model: Gift.dummy()) {
    _initializeStreams(eventID: eventID);
  }

  late final Stream<List<Gift>> giftsStream;

  void _initializeStreams({String? eventID}) {
    List<Map<String, QueryArg>> queryArgs = eventID != null ? [{'eventID' : QueryArg(isEqualTo: eventID)}] : [{}];

    giftsStream = giftCRUD.getSnapshotsWhere(queryArgs)
        .map((snapshot) => snapshot.docs.map((doc) => doc.data() as Gift).toList());
  }


  static GiftBloc get(context) => BlocProvider.of(context);

}