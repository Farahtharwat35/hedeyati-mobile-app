import 'package:hedeyati/database/firestore/crud.dart';
import 'package:hedeyati/helpers/query_arguments.dart';

Future<bool> userDataUniquenessValidator(
    {required String username,
    required String phone} ) async {

  final result1  = await userCRUD.getWhere([{'username': QueryArg(isEqualTo: username)}]);
  final result2  = await userCRUD.getWhere([{'phone': QueryArg(isEqualTo: phone)}]);
  return result1.isEmpty && result2.isEmpty;

}
