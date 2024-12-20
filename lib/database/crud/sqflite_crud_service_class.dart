import 'dart:async';
import 'dart:developer';
import '../../helpers/dataMapper.dart';
import '../../helpers/id_generator.dart';
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
  static Future<void> batchAlterModel(String table, AlterType alterType, List<Map<String, Object?>> values,
      {String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm}) async {
    log('=================Batch Altering $table==============================');
    final db = await SqliteConnectionFactory().openConnection();
    final batch = db.batch();
    for (var value in values) {
      value['isDeleted'] = value['isDeleted'] == false ? 0 : 1;
      value['id'] ??= uuIDGenerator();
      switch (alterType) {
        case AlterType.update:
          value['updatedAt'] ??= DateTime.now().toIso8601String();
          batch.update(table, value, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm);
          break;
        case AlterType.delete:
          value['deletedAt'] ??= DateTime.now().toIso8601String();
          value['isDeleted'] = 1;
          batch.delete(table, where: where, whereArgs: whereArgs);
          break;
        case AlterType.insert:
          value['createdAt'] ??= DateTime.now().toIso8601String();
          log('//////////////////// Data Being Inserted : $value //////////////////////');
          batch.insert(table, value, conflictAlgorithm: conflictAlgorithm);
          break;
      }
    }
    await batch.commit(noResult: true);
    log('=================Batch Altering $table Completed==============================');
  }


  static Future<List<Map<String, Object?>>> getWhere(String table, {String? where, List<Object?>? whereArgs}) async {
    final db = await SqliteConnectionFactory().openConnection();
    return db.query(table, where: where, whereArgs: whereArgs);
  }

  static Future<List<Map<String, Object?>>> getAll(String table) async {
    final db = await SqliteConnectionFactory().openConnection();
    return await db.query(table);
  }

}