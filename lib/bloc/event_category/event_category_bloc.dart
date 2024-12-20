import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/models/event_category.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../generic_bloc/generic_crud_bloc.dart';



class EventCategoryBloc extends ModelBloc<EventCategory> {
  EventCategoryBloc() : super(model: EventCategory.dummy());

  late final Stream<List<EventCategory>> _eventCategoryStream;

  void initializeStreams() {
    _eventCategoryStream = eventCategoryCRUD.getSnapshotsWhere([{'isDeleted': QueryArg(isEqualTo: false)}]).map(
          (snapshot) => snapshot.docs.map((doc) => doc.data() as EventCategory).toList(),
    );
  }

  static EventCategoryBloc get(context) => BlocProvider.of<EventCategoryBloc>(context);

  Stream<List<EventCategory>> get eventCategoryBlocStream => _eventCategoryStream;
}
