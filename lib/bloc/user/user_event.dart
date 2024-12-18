

import 'package:hedeyati/bloc/generic_bloc/generic_crud_events.dart';

class GetUserName extends GenericCRUDEvents {
  final String userId;

  GetUserName({required this.userId});
}