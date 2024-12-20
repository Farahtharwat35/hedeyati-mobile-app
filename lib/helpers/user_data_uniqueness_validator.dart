import 'dart:developer';
import 'package:hedeyati/database/firestore/crud.dart';
import 'package:hedeyati/helpers/query_arguments.dart';

Future<bool> userDataUniquenessValidator(
    {required String username}) async {
  log('***********Checking user data uniqueness***********');
  final result1  = await userCRUD.getWhere([{'username': QueryArg(isEqualTo: username)}]);
  bool areValid = result1.isEmpty;
  log('***********User data uniqueness: $areValid***********');
  return areValid;

}
