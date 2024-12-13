import 'package:sqflite/sqflite.dart';
import 'migration.dart';

class MigrationV2 implements Migration {
  @override
  void create(Batch batch) {

    print('Deleting old tables...');

    // Dropping the old tables as they are very old schemas
    batch.execute('DROP TABLE IF EXISTS User;');
    batch.execute('DROP TABLE IF EXISTS Friendship;');
    batch.execute('DROP TABLE IF EXISTS Gift;');
    batch.execute('DROP TABLE IF EXISTS Event;');
    batch.execute('DROP TABLE IF EXISTS EventCategory;');
    batch.execute('DROP TABLE IF EXISTS GiftCategory;');
    batch.execute('DROP TABLE IF EXISTS EventStatus;');
    batch.execute('DROP TABLE IF EXISTS FriendshipStatus;');

    print('Creating database schema for version 2...');
    batch.execute('''
      CREATE TABLE GiftCategory (
        id TEXT UNIQUE,
        name TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        deletedAt TEXT,
        isDeleted INTEGER NOT NULL
      );
     ''');

  }

  @override
  void update(Batch batch) {
    // TODO: implement update
  }

}
