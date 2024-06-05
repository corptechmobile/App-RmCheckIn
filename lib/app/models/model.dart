import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
part 'model.g.dart';

const tableNfCompra = SqfEntityTable(
  tableName: 'nf_compra',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('chaveNf', DbType.text),
    SqfEntityField('fornecedorDesc', DbType.text),
    SqfEntityField('valorTotal', DbType.real),
    SqfEntityField('statusDesc', DbType.text),
    SqfEntityFieldRelationship(
      parentTable: tableCheckin,
      relationType: RelationType.ONE_TO_MANY,
      deleteRule: DeleteRule.CASCADE,
      fieldName: 'id_checkin',
    ),
    SqfEntityField('numNf', DbType.text),
    SqfEntityField('serieNf', DbType.text),
    SqfEntityField('dtCadastro', DbType.text),
    SqfEntityField('status', DbType.text),
    SqfEntityField('dtEntrada', DbType.datetime),
    SqfEntityField('erpId', DbType.integer),
    SqfEntityField('fornecedorId', DbType.integer),
    SqfEntityField('lojaId', DbType.integer),
    SqfEntityField('excluida', DbType.bool),
    SqfEntityField('dtEmissao', DbType.text),
  ],
);
const tableVeiculo = SqfEntityTable(
  tableName: 'veiculos',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('tipoVeiculo', DbType.text),
    SqfEntityField('placa', DbType.text),
  ],
);

const tableRede = SqfEntityTable(
  tableName: 'redes',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('descricao', DbType.text),
  ],
);

const tableUsuario = SqfEntityTable(
  tableName: 'usuario',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  objectType: ObjectType.table,
  fields: [
    SqfEntityFieldRelationship(
      parentTable: tableVeiculo,
      relationType: RelationType.ONE_TO_MANY,
      deleteRule: DeleteRule.CASCADE,
      fieldName: 'id_veiculo',
    ),
    SqfEntityFieldRelationship(
      parentTable: tableRede,
      relationType: RelationType.ONE_TO_MANY,
      deleteRule: DeleteRule.CASCADE,
      fieldName: 'id_rede',
    ),
    SqfEntityField('cpf', DbType.text),
    SqfEntityField('nome', DbType.text),
    SqfEntityField('email', DbType.text),
    SqfEntityField('telefone', DbType.text),
    SqfEntityField('foto', DbType.text),
    SqfEntityField('status', DbType.text),
  ],
);
const tableCheckin = SqfEntityTable(
  tableName: 'checkin',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  objectType: ObjectType.table,
  fields: [
    SqfEntityField('grupoEmpresarialId', DbType.integer),
    SqfEntityField('fornecedorDesc', DbType.text),
    SqfEntityField('grupoEmpresarialDesc', DbType.text),
    SqfEntityField('lojaId', DbType.integer),
    SqfEntityField('fornecedorId', DbType.integer),
    SqfEntityField('motoristaId', DbType.integer),
    SqfEntityField('dtChegada', DbType.datetime),
    SqfEntityField('dtPrevisaoEntrada', DbType.datetime),
    SqfEntityField('dtEntrada', DbType.datetime),
    SqfEntityField('dtInicio', DbType.datetime),
    SqfEntityField('dtTermino', DbType.datetime),
    SqfEntityField('dtCancelado', DbType.datetime),
    SqfEntityField('status', DbType.text),
    SqfEntityField('statusDesc', DbType.text),
    SqfEntityField('docaDesc', DbType.text),
    SqfEntityField('docaId', DbType.integer),
    SqfEntityField('veiculoId', DbType.integer),
    SqfEntityField('veiculoPlaca', DbType.integer),
    SqfEntityField('veiculoTipoId', DbType.integer),
    SqfEntityField('prioridade', DbType.integer),
    SqfEntityField('lojaDesc', DbType.text),
    SqfEntityField('motoristaNome', DbType.text),
    SqfEntityField('veiculoTipoDesc', DbType.text),
  ],
);

const databaseTableList = [
  tableCheckin,
  tableNfCompra,
  tableUsuario,
  tableRede,
  tableVeiculo,
];
@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  password: null,
  databaseName: "rmccheckin.sqlite",
  databaseTables: databaseTableList,
);
