import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'medication_data.dart';

class DatabaseHelper {
  // Create a singleton instance so we don't open multiple database connections
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medimate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Get the default database directory for the platform (iOS/Android)
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL'; // SQLite uses 0 and 1 for booleans

    await db.execute('''
    CREATE TABLE medications (
      id $idType,
      name $textType,
      dosage $textType,
      time $textType,
      type $textType,
      status $boolType
    )
    ''');
  }

  // INSERT
  Future<Medication> create(Medication medication) async {
    final db = await instance.database;
    await db.insert('medications', medication.toMap());
    return medication;
  }

  // READ ALL
  Future<List<Medication>> readAllMedications() async {
    final db = await instance.database;
    final result = await db.query('medications');
    return result.map((json) => Medication.fromMap(json)).toList();
  }

  // UPDATE
  Future<int> update(Medication medication) async {
    final db = await instance.database;
    return db.update(
      'medications',
      medication.toMap(),
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  // DELETE
  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}