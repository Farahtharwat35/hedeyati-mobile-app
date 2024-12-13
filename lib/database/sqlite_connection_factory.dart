// ignore_for_file: prefer_conditional_assignment

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:hedeyati/database/sqlite_migration_factory.dart';

class SqliteConnectionFactory {
  static const _version = 2;
  static const _databaseName = 'Hedeyaty.db';

  static SqliteConnectionFactory? _instance;

  Database? _db;
  final _lock = Lock();

  SqliteConnectionFactory._();

  factory SqliteConnectionFactory() {
    if (_instance == null) {
      _instance = SqliteConnectionFactory._();
    }
    return _instance!;
  }

  Future<Database> openConnection() async {
    var databasePath = await getDatabasesPath();
    var databasePathFinal = join(databasePath, _databaseName);

    if (_db == null) {
      await _lock.synchronized(() async {
        if (_db == null) {
          // the database can't be created more than 1 time
          _db = await openDatabase(
            databasePathFinal,
            version: _version,
            onConfigure: _onConfigure,
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
            onDowngrade: _onDowngrade,
          );
        }
      });
    }
    return _db!;
  }

  Future<void> closeConnection() async {
    await _db!.close();
    _db = null;
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getCreateMigration();
    for (var migration in migrations) {
      migration.create(batch);
    }

    batch.commit();
  }

  Future<void> _onUpgrade(Database db,int oldVersion ,int version) async {
    print('Upgrading database from $oldVersion to $version...');
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getUpgradeMigration(oldVersion);
    for (var migration in migrations) {
      migration.update(batch);
    }

    await batch.commit();
    print('Database upgrade completed.');
  }

  Future<void> _onDowngrade(Database db, int version, int oldVersion) async {
    print('Downgrading database from $oldVersion to $version...');
    final batch = db.batch();

    final migrations = SqliteMigrationFactory().getUpgradeMigration(oldVersion);
    for (var migration in migrations.reversed) {
      migration.update(batch);
    }

    await batch.commit();
    print('Database downgrade completed.');
  }


  Future<void> deleteDatabaseFile() async {
    var databasePath = await getDatabasesPath();
    var databasePathFinal = join(databasePath, 'Hedeyaty.db');
    await deleteDatabase(databasePathFinal);
    print('Database deleted');
  }
}