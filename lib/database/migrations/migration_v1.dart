import 'package:sqflite/sqflite.dart';
import 'migration.dart';

class MigrationV1 implements Migration {
  @override
  void create(Batch batch) {
    // Dropping the old tables as they are very old schemas
    batch.execute('DROP TABLE IF EXISTS User;');
    batch.execute('DROP TABLE IF EXISTS Friendship;');
    batch.execute('DROP TABLE IF EXISTS Gift;');
    batch.execute('DROP TABLE IF EXISTS Event;');
    batch.execute('DROP TABLE IF EXISTS EventCategory;');
    batch.execute('DROP TABLE IF EXISTS GiftCategory;');
    batch.execute('DROP TABLE IF EXISTS EventStatus;');
    batch.execute('DROP TABLE IF EXISTS FriendshipStatus;');

    batch.execute('''
      CREATE TABLE GiftCategory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
        firebase_id TEXT NOT NULL
        created_at TEXT NOT NULL
        updated_at TEXT NOT NULL
        deleted_at TEXT
        is_deleted INTEGER NOT NULL
      );
    ''');
  }

  @override
  void update(Batch batch) {
    // TODO: implement update
  }

}
