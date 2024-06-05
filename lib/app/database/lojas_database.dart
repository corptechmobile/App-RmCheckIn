import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Loja {
  int? id;
  int? redeId;
  String descricao;
  double latitude;
  double longitude;

  Loja({
    this.id,
    required this.redeId,
    required this.descricao,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'redeId': redeId,
      'descricao': descricao,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Loja.fromMap(Map<String, dynamic> map) {
    return Loja(
      id: map['id'],
      redeId: map['redeId'],
      descricao: map['descricao'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

class DatabaseHelper {
  static const _databaseName = 'lojas_database.db';
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  late Database _database;

  Future<Database> get database async {
    return _database;
  }

  // ignore: unused_element
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE lojas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        redeId INTEGER NOT NULL,
        descricao TEXT,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  Future<int> insertLoja(Loja loja) async {
    final db = await database;
    return await db.insert('lojas', loja.toMap());
  }

  Future<List<Loja>> getAllLojas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('lojas');
    return List.generate(maps.length, (i) {
      return Loja.fromMap(maps[i]);
    });
  }

  Future<int> updateLoja(Loja loja) async {
    final db = await database;
    return await db.update(
      'lojas',
      loja.toMap(),
      where: 'id = ?',
      whereArgs: [loja.id],
    );
  }

  Future<int> deleteLoja(int id) async {
    final db = await database;
    return await db.delete(
      'lojas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
