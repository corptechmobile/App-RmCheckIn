// ignore_for_file: public_member_api_docs, sort_constructors_first
class NFCompra {
  final int id;
  final String chaveNf;
  final String fornecedorDesc;
  final double valorTotal;
  final String statusDesc;
  final int checkInId;
  final String numNf;
  final String serieNf;
  final String dtCadastro;
  final String status;
  final String dtEntrada;
  final int erpId;
  final int lojaId;
  final bool excluida;
  final String dtEmissao;
  final int fornecedorId;
  NFCompra({
    required this.id,
    required this.chaveNf,
    required this.fornecedorDesc,
    required this.valorTotal,
    required this.statusDesc,
    required this.checkInId,
    required this.numNf,
    required this.serieNf,
    required this.dtCadastro,
    required this.status,
    required this.dtEntrada,
    required this.erpId,
    required this.lojaId,
    required this.excluida,
    required this.dtEmissao,
    required this.fornecedorId,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chaveNf': chaveNf,
      'fornecedorDesc': fornecedorDesc,
      'valorTotal': valorTotal,
      'statusDesc': statusDesc,
    };
  }

  factory NFCompra.fromJson(Map<String, dynamic> json) {
    return NFCompra(
      id: json['id'],
      chaveNf: json['chave_nf'],
      fornecedorDesc: json['fornecedor_desc'],
      valorTotal: json['valor_total'],
      statusDesc: json['statusDesc'],
      checkInId: json['checkInId'],
      numNf: json['numNf'],
      serieNf: json['serieNf'],
      dtCadastro: json['dtCadastro'],
      status: json['status'],
      dtEntrada: json['dtEntrada'],
      erpId: json['erpId'],
      excluida: json['excluida'],
      lojaId: json['lojaId']!,
      dtEmissao: json['dtEmissao'],
      fornecedorId: json['fornecedorId'],
    );
  }

  static fromMap(jsonDecode) {}

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
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
    };
  }

  @override
  String toString() {
    return 'NotaFiscal(id: $id, chaveNf: $chaveNf, fornecedorDesc: $fornecedorDesc, valorTotal: $valorTotal, statusDesc: $statusDesc, checkInId: $checkInId, numNf: $numNf, serieNf: $serieNf, dtCadastro: $dtCadastro, status: $status, dtEntrada: $dtEntrada)';
  }

  @override
  bool operator ==(covariant NFCompra other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.chaveNf == chaveNf &&
        other.fornecedorDesc == fornecedorDesc &&
        other.valorTotal == valorTotal &&
        other.statusDesc == statusDesc &&
        other.checkInId == checkInId &&
        other.numNf == numNf &&
        other.serieNf == serieNf &&
        other.dtCadastro == dtCadastro &&
        other.status == status &&
        other.dtEntrada == dtEntrada;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        chaveNf.hashCode ^
        fornecedorDesc.hashCode ^
        valorTotal.hashCode ^
        statusDesc.hashCode ^
        checkInId.hashCode ^
        numNf.hashCode ^
        serieNf.hashCode ^
        dtCadastro.hashCode ^
        status.hashCode ^
        dtEntrada.hashCode;
  }
}
