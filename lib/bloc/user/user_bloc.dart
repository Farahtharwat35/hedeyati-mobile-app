import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/bloc/user/user_event.dart';
import 'package:hedeyati/bloc/user/user_states.dart';
import '../../database/firestore/crud.dart';
import '../../helpers/query_arguments.dart';
import '../../helpers/response.dart';
import '../../models/user.dart';
import '../generic_bloc/generic_crud_bloc.dart';

class UserBloc extends ModelBloc<User> {
  UserBloc() : super(model: User.dummy()) {
    on<GetUserName>(getUserNameByID);
  }

  getUserNameByID(GetUserName event ,  Emitter emit) async {
    log('***********Getting user name***********');
   List<User> users = await userCRUD.getWhere([{'id': QueryArg(isEqualTo: event.userId)}]);
    if (users.isNotEmpty) {
      log('***********User name: ${users.first.username}***********');
      emit(UserNameLoaded(users.first.username));
    } else {
      log('***********Failed to get user name***********');
      emit(ModelErrorState(message: Response(success: false, message: 'Failed to get user name')));
    }

  }

  static UserBloc get(context) => BlocProvider.of(context);
}