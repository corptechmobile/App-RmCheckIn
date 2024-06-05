import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'checkin_data';
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }
  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'checkin_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            chaveNf TEXT,
            fornecedorDesc TEXT,
            numNf TEXT,
            statusDesc TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertCheckInData(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> getCheckInData() async {
    final db = await database;
    return await db.query(tableName);
  }
}
