
import 'package:hedeyati/bloc/generic_bloc/generic_states.dart';
import 'package:hedeyati/helpers/response.dart';

class UserCredentialsValidated extends ModelStates {
  final Response message;

  const UserCredentialsValidated({required this.message});

  @override
  List<Object?> get props => [message];

}