import 'package:sqflite/sqflite.dart';

class Veiculo {
  final int? id;
  final String placa;
  final String tipoVeiculo;
  final String foto;

  Veiculo({this.id, required this.placa, required this.tipoVeiculo, required this.foto});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placa': placa,
      'tipoVeiculo': tipoVeiculo,
      'foto': foto,
    };
  }

  static Veiculo fromMap(Map<String, dynamic> map) {
    return Veiculo(
      id: map['id'],
      placa: map['placa'],
      tipoVeiculo: map['tipoVeiculo'],
      foto: map['foto'],
    );
  }
}

class VeiculoDatabase {
  late Database _db;

  Future<void> open() async {
    _db = await openDatabase(
      'veiculos.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE veiculos(id INTEGER PRIMARY KEY AUTOINCREMENT, placa TEXT, tipoVeiculo TEXT, foto TEXT)',
        );
      },
    );
  }

  Future<int> insertVeiculo(Veiculo veiculo) async {
    await open();
    return await _db.insert('veiculos', veiculo.toMap());
  }

  Future<List<Veiculo>> getVeiculos() async {
    await open();
    final List<Map<String, dynamic>> maps = await _db.query('veiculos');
    return List.generate(maps.length, (i) {
      return Veiculo.fromMap(maps[i]);
    });
  }

  Future<void> updateVeiculo(Veiculo veiculo) async {
    await open();
    await _db.update(
      'veiculos',
      veiculo.toMap(),
      where: 'id = ?',
      whereArgs: [veiculo.id],
    );
  }

  Future<void> deleteVeiculo(int id) async {
    await open();
    await _db.delete(
      'veiculos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    await _db.close();
  }
}
