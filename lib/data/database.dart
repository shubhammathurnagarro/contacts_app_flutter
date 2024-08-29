import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/contact.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> _getDB() async {
    return _database ??= await _initDB();
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), '${ColumnNames.tableName}.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      return db.execute('''
        CREATE TABLE ${ColumnNames.tableName}(
          ${ColumnNames.id} INTEGER PRIMARY KEY,
          ${ColumnNames.name} TEXT NOT NULL,
          ${ColumnNames.mobile} TEXT NOT NULL,
          ${ColumnNames.landline} TEXT,
          ${ColumnNames.photoPath} TEXT,
          ${ColumnNames.isFavorite} INTEGER NOT NULL DEFAULT 0
        )
      ''');
    });
  }

  Future<int> insertContact(Contact contact) async {
    final db = await _getDB();
    return await db.insert(ColumnNames.tableName, contact.toMap());
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await _getDB();
    final List<Map<String, Object?>> items =
        await db.query(ColumnNames.tableName, orderBy: ColumnNames.name);
    return items.map((json) => Contact.fromMap(json)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await _getDB();
    return await db.update(
      ColumnNames.tableName,
      contact.toMap(),
      where: '${ColumnNames.id} = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int contactId) async {
    final db = await _getDB();
    return await db.delete(
      ColumnNames.tableName,
      where: '${ColumnNames.id} = ?',
      whereArgs: [contactId],
    );
  }

  Future<int> upsertContact(Contact contact) async {
    return contact.id > 0 ? updateContact(contact) : insertContact(contact);
  }

  Future<List<Contact>> getFavoriteContacts() async {
    final db = await _getDB();
    final List<Map<String, Object?>> items = await db.query(ColumnNames.tableName,
        where: '${ColumnNames.isFavorite} = ?', whereArgs: [1], orderBy: ColumnNames.name);
    return items.map((json) => Contact.fromMap(json)).toList();
  }
}

abstract final class ColumnNames {
  static const String tableName = 'contacts';

  static const String id = 'id';
  static const String name = 'name';
  static const String mobile = 'mobile';
  static const String landline = 'landline';
  static const String photoPath = 'photo_path';
  static const String isFavorite = 'is_favorite';
}
