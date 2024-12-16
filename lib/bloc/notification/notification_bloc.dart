import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_crud_bloc.dart';
import 'package:hedeyati/models/notification.dart' as NotificationModel;
import 'package:rxdart/rxdart.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';

class NotificationBloc extends ModelBloc<NotificationModel.Notification> {
  NotificationBloc() : super(model: NotificationModel.Notification.dummy());

  // Controller to manage the notifications stream
  final BehaviorSubject<List<NotificationModel.Notification>> _notificationsController =
  BehaviorSubject<List<NotificationModel.Notification>>.seeded([]);

  // Expose the notifications stream
  Stream<List<NotificationModel.Notification>> get myNotificationsStream => _notificationsController.stream;

  // Access the latest notifications value
  List<NotificationModel.Notification> get currentNotifications => _notificationsController.value;

  // Method to initialize the notifications stream
  void initializeStreams() {
    final notificationsStream = notificationCRUD
        .getSnapshotsWhere([
      {'receiverID': QueryArg(isEqualTo: FirebaseAuth.instance.currentUser!.uid)},
      {'isDeleted': QueryArg(isEqualTo: false)}
    ])
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as NotificationModel.Notification).toList());

    // Listen to the notifications stream and update the BehaviorSubject
    notificationsStream.listen((notifications) {
      _notificationsController.add(notifications);
    });
  }

  // A static method to easily get the instance of this bloc in the widget tree
  static NotificationBloc get(context) => BlocProvider.of(context);

  // Dispose the BehaviorSubject when the bloc is closed
  @override
  Future<void> close() {
    _notificationsController.close();
    return super.close();
  }
}
