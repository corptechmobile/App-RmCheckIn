import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int id;
  final String cpf;
  final String nome;
  final String email;
  final String telefone;
  final String foto;

  User({
    required this.id,
    required this.cpf,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.foto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cpf': cpf,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'foto': foto,
    };
  }
}

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'user_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY,
            cpf TEXT,
            nome TEXT,
            email TEXT,
            telefone TEXT,
            foto TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db!.insert('users', user.toMap());
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('users');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        cpf: maps[i]['cpf'],
        nome: maps[i]['nome'],
        email: maps[i]['email'],
        telefone: maps[i]['telefone'],
        foto: maps[i]['foto'],
      );
    });
  }
}
