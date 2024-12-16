import '../../models/user.dart';
import '../generic_bloc/generic_crud_events.dart';

class ValidateCredentialsUniqueness extends GenericCRUDEvents {
  ValidateCredentialsUniqueness({required this.username, required this.phoneNumber});

  final String username;
  final String phoneNumber;

  @override
  List<Object?> get props => [username, phoneNumber];
}

class CreateUserAccount extends GenericCRUDEvents {
  CreateUserAccount({required this.user , required this.password});

  final String password;
  final User user;


  @override
  List<Object?> get props => [user, password];
}