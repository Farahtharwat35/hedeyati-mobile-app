import 'dart:developer';
import 'package:hedeyati/database/firestore/crud.dart';
import 'package:hedeyati/helpers/query_arguments.dart';

Future<bool> userDataUniquenessValidator(
    {required String username,
    required String phone} ) async {
  log('***********Checking user data uniqueness***********');
  final result1  = await userCRUD.getWhere([{'username': QueryArg(isEqualTo: username)}]);
  final result2  = await userCRUD.getWhere([{'phoneNumber': QueryArg(isEqualTo: phone)}]);
  bool areValid = result1.isEmpty && result2.isEmpty;
  log('***********User data uniqueness: $areValid***********');
  return areValid;

}
