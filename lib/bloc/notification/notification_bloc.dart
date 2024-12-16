import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_bloc.dart';
import 'package:hedeyati/models/notification.dart' as NotificationModel;
import 'package:rxdart/rxdart.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';

class NotificationBloc extends ModelBloc<NotificationModel.Notification> {
  NotificationBloc() : super(model: NotificationModel.Notification.dummy());

  late Stream<List<NotificationModel.Notification>> _notificationsStream;

  // Method to initialize the notifications stream
  void initializeStreams() {
    _notificationsStream = notificationCRUD
        .getSnapshotsWhere([
      {'receiverID': QueryArg(isEqualTo: FirebaseAuth.instance.currentUser!.uid)},
      {'isDeleted': QueryArg(isEqualTo: false)}
    ]).map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as NotificationModel.Notification).toList());
  }

  Stream<List<NotificationModel.Notification>> get currentNotifications => _notificationsStream;

  // A static method to easily get the instance of this bloc in the widget tree
  static NotificationBloc get(context) => BlocProvider.of(context);

}
