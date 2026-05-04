import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // Opens or creates the database file
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'medimate.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE medications(id TEXT PRIMARY KEY, name TEXT, dosage TEXT, time TEXT, type TEXT, isTaken INTEGER)',
        );
      },
      version: 1,
    );
  }

  // Insert a new medication
  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DBHelper.database();
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all medications
  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  // Update only the "taken" status
  static Future<void> updateStatus(String id, bool isTaken) async {
    final db = await DBHelper.database();
    await db.update(
      'medications',
      {'isTaken': isTaken ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a medication
  static Future<void> delete(String id) async {
    final db = await DBHelper.database();
    await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}