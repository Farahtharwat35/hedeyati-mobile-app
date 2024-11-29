import 'dart:async';
import '../sqlite_connection_factory.dart';
import 'package:hedeyati/models/gift.dart';


class GiftsHelper {
  Future<List<Map<String, dynamic>>> fetchGifts() async {
    final db = await SqliteConnectionFactory().openConnection();
    return await db.query('gift');
  }

  Future<void> addGift(Map<String, dynamic> gift) async {
    final db = await SqliteConnectionFactory().openConnection();
    await db.insert('gift', gift);
  }

  Future<void> updateGift(int id, Map<String, dynamic> updatedData) async {
    final db = await SqliteConnectionFactory().openConnection();
    await db.update(
      'gift',
      updatedData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteGift(int id) async {
    final db = await SqliteConnectionFactory().openConnection();
    await db.delete(
      'gift',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllGifts() async {
    final db = await SqliteConnectionFactory().openConnection();
    await db.delete('gift');
  }

 Future<List<Map<String, dynamic>>> fetchGiftsByUserId(int userId) async {
    final db = await SqliteConnectionFactory().openConnection();
    return await db.query(
      'gift',
      where: 'user_id = ?',
      whereArgs: [userId],
    );}

  Future<List<dynamic>> fetchPledgedGifts() async {
    final db = await SqliteConnectionFactory().openConnection();
    final pledgedGifts = await db.query(
      'gift',
      where: 'is_pledged = ?',
      whereArgs: [1],
    );
    return pledgedGifts.map((gift) => Gift.fromJson(gift)).toList();
  }
}