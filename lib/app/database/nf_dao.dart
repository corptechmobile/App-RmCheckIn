/* import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:sqflite/sqflite.dart';

// Define a tabela NFCompra
final nfCompraTable = const SqfEntityTable(
  tableName: 'nf_compra',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  fields: [
    SqfEntityField('chaveNf', DbType.text),
    SqfEntityField('fornecedorDesc', DbType.text),
    SqfEntityField('valorTotal', DbType.real),
    SqfEntityField('statusDesc', DbType.text),
    SqfEntityField('checkInId', DbType.integer),
    SqfEntityField('numNf', DbType.text),
    SqfEntityField('serieNf', DbType.text),
    SqfEntityField('dtCadastro', DbType.text),
    SqfEntityField('status', DbType.text),
    SqfEntityField('dtEntrada', DbType.text),
    SqfEntityField('erpId', DbType.integer),
  ],
);

// Define o modelo NFCompra
class NFCompra extends SqfEntityModel {
  NFCompra();

  String? chaveNf;
  String? fornecedorDesc;
  double? valorTotal;
  String? statusDesc;
  int? checkInId;
  String? numNf;
  String? serieNf;
  String? dtCadastro;
  String? status;
  String? dtEntrada;
  int? erpId;

  NFCompra.fromMap(Map<String, dynamic> map) {
    this.chaveNf = map['chaveNf'];
    this.fornecedorDesc = map['fornecedorDesc'];
    this.valorTotal = map['valorTotal'];
    this.statusDesc = map['statusDesc'];
    this.checkInId = map['checkInId'];
    this.numNf = map['numNf'];
    this.serieNf = map['serieNf'];
    this.dtCadastro = map['dtCadastro'];
    this.status = map['status'];
    this.dtEntrada = map['dtEntrada'];
    this.erpId = map['erpId'];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'chaveNf': chaveNf,
      'fornecedorDesc': fornecedorDesc,
      'valorTotal': valorTotal,
      'statusDesc': statusDesc,
      'checkInId': checkInId,
      'numNf': numNf,
      'serieNf': serieNf,
      'dtCadastro': dtCadastro,
      'status': status,
      'dtEntrada': dtEntrada,
      'erpId': erpId,
    };
  }
}

// Define o database
SqfEntityDbModel nfCompraDatabaseModel() {
  return SqfEntityDbModel(
    modelName: 'NFCompraDatabase',
    databaseName: 'nfcompra.db',
    databaseTables: [nfCompraTable],
    bundledDatabasePath: null,
    dbVersion: 1,
    tableCreationConflictAlgorithm: ConflictAlgorithm.replace,
    modelDynamicType: true,
  );
}

// Define o CRUD
class NFCompraDatabase {
  static Future<int> create(NFCompra nfCompra) async {
    return await nfCompraTable.insert(nfCompra.toMap());
  }

  static Future<NFCompra?> readNFCompra(int id) async {
    return await nfCompraTable.select().id.equals(id).toSingle();
  }

  static Future<List<NFCompra>> readAllNFCompras() async {
    return await nfCompraTable.select().toList();
  }

  static Future<int> update(NFCompra nfCompra) async {
    return await nfCompraTable.update(nfCompra.toMap());
  }

  static Future<int> delete(int id) async {
    return await nfCompraTable.delete(id);
  }

  static Future<void> close() async {}
}
 */