import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/gift.dart';
import '../../models/user.dart';
import '../generic_bloc/generic_crud_bloc.dart';

class UserBloc extends ModelBloc<User> {
  UserBloc() : super(model: User.dummy());

  static UserBloc get(context) => BlocProvider.of(context);

}