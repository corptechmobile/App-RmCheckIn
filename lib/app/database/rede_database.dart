import 'package:sqflite/sqflite.dart';

class Rede {
  final int? id;
  final String descricao;
  final String status;

  Rede({this.id, required this.descricao, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'status': status,
    };
  }

  static Rede fromMap(Map<String, dynamic> map) {
    return Rede(
      id: map['id'],
      descricao: map['descricao'],
      status: map['status'],
    );
  }
}

class RedeDatabase {
  late Database _db;
  Future<void> open() async {
    _db = await openDatabase(
      'rede.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE rede(id INTEGER PRIMARY KEY AUTOINCREMENT, descricao TEXT, status TEXT,)',
        );
      },
    );
  }

  Future<int> insertVeiculo(Rede rede) async {
    await open();
    return await _db.insert('veiculos', rede.toMap());
  }

  Future<List<Rede>> getVeiculos() async {
    await open();
    final List<Map<String, dynamic>> maps = await _db.query('veiculos');
    return List.generate(maps.length, (i) {
      return Rede.fromMap(maps[i]);
    });
  }

  Future<void> updateVeiculo(Rede rede) async {
    await open();
    await _db.update(
      'rede',
      rede.toMap(),
      where: 'id = ?',
      whereArgs: [rede.id],
    );
  }

  Future<void> deleteVeiculo(int id) async {
    await open();
    await _db.delete(
      'rede',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    await _db.close();
  }
}
