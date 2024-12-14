import 'package:flutter/material.dart';
import 'package:hedeyati/database/sqlite_connection_factory.dart';
import 'package:sqflite/sqflite.dart';

import 'sqflite_crud_service_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dbInstance = await SqliteConnectionFactory();
  try {
    // await dbInstance.deleteDatabaseFile();
    final db = await dbInstance.openConnection();
    final version = await db.getVersion();
    print('Database version: $version');
    print("Test started");
    await listTables(db);
    await checkTableExistence(db);
    await getTableSchema(db, 'GiftCategory');
    await getTableData(db, 'GiftCategory');
    await SqliteDatabaseCRUD.getAll('GiftCategory');
  } catch (e) {
    print('Error: $e');
  }
  await SqliteConnectionFactory().closeConnection();
}

Future<void> listTables(Database db) async {
  final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table';");
  print('Tables in the database: ${tables.map((e) => e['name']).toList()}');
}

Future<void> checkTableExistence(Database db) async {
  final table = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='GiftCategory';");
  print('Table existence: ${table.isNotEmpty}');
}

Future<void> getTableSchema(Database db, String tableName) async {
  final table = await db.rawQuery("PRAGMA table_info($tableName);");
  print('Table schema: ${table.map((e) => e['name']).toList()}');
}

Future<void> getTableData(Database db, String tableName) async {
  final table = await db.query(tableName);
  print('Table data: $table');
}