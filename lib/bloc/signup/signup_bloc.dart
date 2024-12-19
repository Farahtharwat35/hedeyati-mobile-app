import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hedeyati/bloc/signUp/signup_events.dart';
import 'package:hedeyati/bloc/signUp/signup_states.dart';
import 'package:hedeyati/database/firestore/crud.dart';
import 'package:hedeyati/helpers/response.dart';
import 'package:hedeyati/models/user.dart' as User;
import '../../authentication/signup_by_email_and_password.dart';
import '../../helpers/user_data_uniqueness_validator.dart';
import '../generic_bloc/generic_crud_bloc.dart';
import '../generic_bloc/generic_states.dart';

class SignupBloc extends ModelBloc<User.User> {
  SignupBloc() : super(model: User.User.dummy()) {
    // on<ValidateCredentialsUniqueness>(validateCredentialsUniqueness);
    on<CreateUserAccount>(createUserAccount);
  }

  Future<bool> validateCredentialsUniqueness(String username, String phoneNumber) async {
    final bool areValid = await userDataUniquenessValidator(username: username, phone: phoneNumber);
    return areValid;
  }

  Future<void> createUserAccount(CreateUserAccount event, Emitter emit) async {
    bool areValid = await validateCredentialsUniqueness(event.user.username, event.user.phoneNumber);
    if (!areValid) {
      log('***********Username or Phone number already exists***********');
      emit(UserCredentialsValidated(message: Response(success: false, message: 'Username or Phone number already exists')));
      return;
    }
    Response response = await SignUpByEmailAndPassword.signUp(email: event.user.email, password: event.password);
    try {
      if (response.success) {
        try {
          event.user.id = FirebaseAuth.instance.currentUser!.uid;
          await userCRUD.add(model:event.user, uuID: false);
          emit(ModelSuccessState(message: response));
        } catch (e) {
          emit(ModelErrorState(message: Response(success: false, message: 'Failed to add model: $e')));
        }
      } else {
        emit(ModelErrorState(message: response));
      }
    } catch (e) {
      emit(ModelErrorState(message: Response(success: false, message: 'Something went wrong')));
    }
  }

  static SignupBloc get(context) => BlocProvider.of(context);

}