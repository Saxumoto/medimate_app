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

    return await openDatabase(
      path,
      version: 4, // Bumped version
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE medications ADD COLUMN frequency TEXT DEFAULT ""');
      await db.execute('ALTER TABLE medications ADD COLUMN notes TEXT DEFAULT ""');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE user_profile ADD COLUMN phone TEXT DEFAULT ""');
      await db.execute('ALTER TABLE user_profile ADD COLUMN address TEXT DEFAULT ""');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE user_profile ADD COLUMN profileImage TEXT DEFAULT ""');
    }
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
      status $boolType,
      frequency TEXT DEFAULT "",
      notes TEXT DEFAULT ""
    )
    ''');

    await db.execute('''
    CREATE TABLE user_profile (
      id $idType,
      name $textType,
      email $textType,
      dob $textType,
      gender $textType,
      weight $textType,
      height $textType,
      bloodType $textType,
      phone TEXT DEFAULT "",
      address TEXT DEFAULT "",
      profileImage TEXT DEFAULT ""
    )
    ''');
  }

  // INSERT PROFILE
  Future<void> saveProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    await db.insert('user_profile', profile, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // READ PROFILE
  Future<Map<String, dynamic>?> getProfile() async {
    final db = await instance.database;
    final maps = await db.query('user_profile', limit: 1);
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
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