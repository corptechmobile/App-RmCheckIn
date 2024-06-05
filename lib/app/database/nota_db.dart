// import 'package:path/path.dart';
// import 'package:rmcheckin/app/model/nf_compra.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();

//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) {
//       return _database!;
//     }

//     _database = await initDatabase();
//     return _database!;
//   }

//   Future<Database> initDatabase() async {
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, 'your_database_name.db');

//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         // Crie suas tabelas aqui
//         await db.execute('''
//           CREATE TABLE IF NOT EXISTS notas (
//             id INTEGER PRIMARY KEY,
//             chaveNf TEXT,
//             fornecedorDesc TEXT,
//             valorTotal REAL,
//             statusDesc TEXT,
//             checkInId INTEGER,
//             numNf TEXT,
//             serieNf TEXT,
//             dtCadastro TEXT,
//             status TEXT,
//             dtEntrada TEXT
//           )
//         ''');
//       },
//     );
//   }

//   Future<int> insertNota(NFCompra nota) async {
//     final Database db = await database;
//     return await db.insert('notas', nota.toMap());
//   }

//   Future<int> updateNota(NFCompra nota) async {
//     final Database db = await database;
//     return await db.update('notas', nota.toMap(), where: 'id = ?', whereArgs: [nota.id]);
//   }

//   Future<int> deleteNota(int id) async {
//     final Database db = await database;
//     return await db.delete('notas', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<List<NFCompra>> getAllNotas() async {
//     final Database db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('notas');
//     return List.generate(maps.length, (i) {
//       return NFCompra.fromMap(maps[i]);
//     });
//   }
// }
