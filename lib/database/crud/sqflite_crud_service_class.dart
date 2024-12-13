import 'dart:async';
import '../../helpers/timestamp_stringConverter.dart';
import '../sqlite_connection_factory.dart';
import 'package:sqflite/sqflite.dart';

enum AlterType {
  update,
  delete,
  insert,
}

class SqliteDatabaseCRUD {

  static Future<void> alterModel(String table, AlterType alterType ,Map<String,Object?> values, {String? where,List<Object?>? whereArgs,ConflictAlgorithm? conflictAlgorithm , bool batch=false}) async {
    final db = await SqliteConnectionFactory().openConnection();
    switch (alterType) {
      case AlterType.update:
        await db.update(table, values, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm);
        break;
      case AlterType.delete:
        await db.delete(table, where: where, whereArgs: whereArgs);
        break;
      case AlterType.insert:
        await db.insert(table, values, conflictAlgorithm: conflictAlgorithm);
        break;
    }
  }

  static Future<void> batchAlterModel(String table, AlterType alterType ,List<Map<String,Object?>> values, {String? where,List<Object?>? whereArgs,ConflictAlgorithm? conflictAlgorithm}) async {
    print('=================Batch Altering $table==============================');
    final db = await SqliteConnectionFactory().openConnection();
    final batch = db.batch();
    for (var value in values) {
      value['isDeleted'] == false ? value['isDeleted'] = 0 : value['isDeleted'] = 1;
      switch (alterType) {
        case AlterType.update:
          batch.update(table, value, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm);
          break;
        case AlterType.delete:
          batch.delete(table, where: where, whereArgs: whereArgs);
          break;
        case AlterType.insert:
          batch.insert(table, value, conflictAlgorithm: conflictAlgorithm);
          break;
      }
    }
    await batch.commit(noResult: true);
    print('=================Batch Altering $table Completed==============================');
  }

  static Future<List<Map<String, Object?>>> getWhere(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await SqliteConnectionFactory().openConnection();
    return db.query(table, where: where, whereArgs: whereArgs);
  }

}