import 'package:sqflite/sqflite.dart';
import 'migration.dart';

class MigrationV0 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone_number TEXT UNIQUE NOT NULL,
        is_deleted INTEGER DEFAULT 0
      );
    ''');

    batch.execute('''
      CREATE TABLE Friendship (
        userID INTEGER NOT NULL,
        friendID INTEGER NOT NULL,
        friendshipStatus INTEGER NOT NULL,
        FOREIGN KEY (userID) REFERENCES User(id),
        FOREIGN KEY (friendID) REFERENCES User(id),
        FOREIGN KEY (friendshipStatus) REFERENCES FriendshipStatus(id),
        PRIMARY KEY (userID, friendID)
      );
    ''');

    batch.execute('''
      CREATE TABLE Gift (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        photo_url TEXT,
        is_pledged INTEGER DEFAULT 0,
        pledged_by INTEGER,
        pledge_date DATETIME,
        price REAL NOT NULL,
        categoryID INTEGER NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        stores_location_recommendation TEXT,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (pledged_by) REFERENCES User(id),
        FOREIGN KEY (categoryID) REFERENCES GiftCategory(id)
      );
    ''');

    batch.execute('''
      CREATE TABLE Event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        categoryID INTEGER NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE,
        status INTEGER NOT NULL,
        created_by INTEGER NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        deleted_at DATETIME,
        FOREIGN KEY (categoryID) REFERENCES EventCategory(id),
        FOREIGN KEY (status) REFERENCES EventStatus(id),
        FOREIGN KEY (created_by) REFERENCES User(id)
      );
    ''');

    batch.execute('''
      CREATE TABLE EventCategory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    batch.execute('''
      CREATE TABLE GiftCategory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    batch.execute('''
      CREATE TABLE EventStatus (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        status TEXT NOT NULL
      );
    ''');

    batch.execute('''
      CREATE TABLE FriendshipStatus (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        status TEXT NOT NULL
      );
    ''');

    // Insert initial data //

    batch.execute('''
  INSERT INTO GiftCategory (name) VALUES
  ('Electronics'), 
  ('Clothing'), 
  ('Books');
''');

    batch.execute('''
  INSERT INTO EventCategory (name) VALUES
  ('Birthday'), 
  ('Anniversary'), 
  ('Graduation');
''');

    batch.execute('''
  INSERT INTO EventStatus (status) VALUES
  ('Upcoming'), 
  ('Ongoing'), 
  ('Completed');
''');

    batch.execute('''
  INSERT INTO FriendshipStatus (status) VALUES
  ('Pending'), 
  ('Accepted'), 
  ('Blocked');
''');
  }

  @override
  void update(Batch batch) {}
}
