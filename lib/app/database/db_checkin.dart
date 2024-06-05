import 'dart:async';
import 'package:rmcheckin/app/models/nf_compra.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CheckInDataBse {
  static final CheckInDataBse instance = CheckInDataBse._init();

  static Database? _database;
  CheckInDataBse._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('checkIn.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE checkIn(
        
        grupoEmpresarialId TEXT,
        fornecedorDesc TEXT,
        grupoEmpresarialDesc TEXT,
        lojaId TEXT,
        fornecedorId TEXT,
        motoristaId TEXT,
        dtChegada TEXT,
        dtPrevisaoEntrada TEXT,
        dtEntrada TEXT,
        dtInicio TEXT,
        dtTermino TEXT, 
        dtCancelado TEXT, 
        status TEXT, 
        statusDesc TEXT, 
        docaDesc TEXT, 
        docaId INTERGER      
      )
    ''');
  }

  Future<int> create(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('checkIn', row);
  }

  Future<Map<String, dynamic>?> read(int id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'checkIn',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> readAll() async {
    final db = await instance.database;
    return await db.query('checkIn');
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await instance.database;
    final int id = row['id'];
    return await db.update(
      'checkIn',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'checkIn',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
