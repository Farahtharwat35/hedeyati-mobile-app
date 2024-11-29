import 'package:flutter/widgets.dart'; // Required for WidgetsFlutterBinding
import 'package:hedeyati/database/sqlite_connection_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  final db = await SqliteConnectionFactory().openConnection();
  print('Database initialized!');
  List<Map<String, dynamic>> tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
  print('Tables: $tables');
  List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM FriendshipStatus');
  print('FriendshipStatus data: $result');
  db.close();
}
