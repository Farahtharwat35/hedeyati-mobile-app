import 'package:uuid/uuid.dart';

String uuIDGenerator() {
  final uuid = Uuid();
  return uuid.v4();
}