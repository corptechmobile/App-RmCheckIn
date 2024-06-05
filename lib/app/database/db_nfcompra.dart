import 'package:sqfentity_gen/sqfentity_gen.dart';

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
    SqfEntityField('checkInId', DbType.integer),
    SqfEntityField('numNf', DbType.text),
    SqfEntityField('serieNf', DbType.text),
    SqfEntityField('dtCadastro', DbType.text),
    SqfEntityField('status', DbType.text),
    SqfEntityField('dtEntrada', DbType.text),
    SqfEntityField('erpId', DbType.integer),
    SqfEntityField('id', DbType.integer),
    SqfEntityField('fornecedorId', DbType.integer),
    SqfEntityField('lojaId', DbType.integer),
    SqfEntityField('excluida', DbType.bool),
    SqfEntityField('dtEmissao', DbType.text)
  ],
);
const tableCheckin = SqfEntityTable(
  tableName: 'checkin',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  objectType: ObjectType.table,
  fields: [
    SqfEntityFieldRelationship(
      parentTable: tableNfCompra,
      relationType: RelationType.ONE_TO_MANY,
      deleteRule: DeleteRule.CASCADE,
      fieldName: 'id_mapaentrega',
    ),
    SqfEntityField('grupoEmpresarialId', DbType.text),
    SqfEntityField('fornecedorDesc', DbType.text),
    SqfEntityField('grupoEmpresarialDesc', DbType.text),
    SqfEntityField('lojaId', DbType.text),
    SqfEntityField('fornecedorId', DbType.text),
    SqfEntityField('motoristaId', DbType.text),
    SqfEntityField('dtChegada', DbType.text),
    SqfEntityField('dtPrevisaoEntrada', DbType.text),
    SqfEntityField('dtEntrada', DbType.text),
    SqfEntityField('dtInicio', DbType.text),
    SqfEntityField('dtTermino', DbType.text),
    SqfEntityField('dtCancelado', DbType.text),
    SqfEntityField('status', DbType.text),
    SqfEntityField('statusDesc', DbType.text),
    SqfEntityField('docaDesc', DbType.text),
    SqfEntityField('docaId', DbType.integer),
  ],
);

const databaseTableList = [
  tableCheckin,
  tableNfCompra,
];
@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  password: null,
  databaseTables: databaseTableList,
);
