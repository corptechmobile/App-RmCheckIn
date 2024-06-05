class CheckInResponse {
  RegistarCheckinModel? data;
  List<String> errors;

  CheckInResponse({this.data, required this.errors});

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      data: json['data'] != null ? RegistarCheckinModel.fromJson(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : <String>[],
    );
  }
}

class RegistarCheckinModel {
  int id;
  int grupoEmpresarialId;
  String grupoEmpresarialDesc;
  int lojaId;
  String lojaDesc;
  int fornecedorId;
  String fornecedorDesc;
  int motoristaId;
  String motoristaNome;
  int veiculoId;
  String veiculoPlaca;
  int veiculoTipoId;
  String veiculoTipoDesc;
  int prioridade;
  String dtChegada;
  String? dtPrevisaoEntrada;
  String? dtEntrada;
  String? dtInicio;
  String? dtTermino;
  String? dtCancelado;
  String status;
  String statusDesc;
  List<Nota> notas;

  RegistarCheckinModel({
    required this.id,
    required this.grupoEmpresarialId,
    required this.grupoEmpresarialDesc,
    required this.lojaId,
    required this.lojaDesc,
    required this.fornecedorId,
    required this.fornecedorDesc,
    required this.motoristaId,
    required this.motoristaNome,
    required this.veiculoId,
    required this.veiculoPlaca,
    required this.veiculoTipoId,
    required this.veiculoTipoDesc,
    required this.prioridade,
    required this.dtChegada,
    this.dtPrevisaoEntrada,
    this.dtEntrada,
    this.dtInicio,
    this.dtTermino,
    this.dtCancelado,
    required this.status,
    required this.statusDesc,
    required this.notas,
  });

  factory RegistarCheckinModel.fromJson(Map<String, dynamic> json) {
    var notasList = json['notas'] as List;
    List<Nota> notas = notasList.map((nota) => Nota.fromJson(nota)).toList();

    return RegistarCheckinModel(
      id: json['id'],
      grupoEmpresarialId: json['grupoEmpresarialId'],
      grupoEmpresarialDesc: json['grupoEmpresarialDesc'],
      lojaId: json['lojaId'],
      lojaDesc: json['lojaDesc'],
      fornecedorId: json['fornecedorId'],
      fornecedorDesc: json['fornecedorDesc'],
      motoristaId: json['motoristaId'],
      motoristaNome: json['motoristaNome'],
      veiculoId: json['veiculoId'],
      veiculoPlaca: json['veiculoPlaca'],
      veiculoTipoId: json['veiculoTipoId'],
      veiculoTipoDesc: json['veiculoTipoDesc'],
      prioridade: json['prioridade'],
      dtChegada: json['dtChegada'],
      dtPrevisaoEntrada: json['dtPrevisaoEntrada'],
      dtEntrada: json['dtEntrada'],
      dtInicio: json['dtInicio'],
      dtTermino: json['dtTermino'],
      dtCancelado: json['dtCancelado'],
      status: json['status'],
      statusDesc: json['statusDesc'],
      notas: notas,
    );
  }
}

class Nota {
  int id;
  int erpId;
  int checkInId;
  int lojaId;
  int fornecedorId;
  String fornecedorDesc;
  dynamic numPedCompra;
  String chaveNf;
  String numNf;
  String serieNf;
  String status;
  String statusDesc;
  String dtEmissao;
  String dtEntrada;
  String dtCadastro;
  double valorTotal;
  bool excluida;

  Nota({
    required this.id,
    required this.erpId,
    required this.checkInId,
    required this.lojaId,
    required this.fornecedorId,
    required this.fornecedorDesc,
    required this.numPedCompra,
    required this.chaveNf,
    required this.numNf,
    required this.serieNf,
    required this.status,
    required this.statusDesc,
    required this.dtEmissao,
    required this.dtEntrada,
    required this.dtCadastro,
    required this.valorTotal,
    required this.excluida,
  });

  factory Nota.fromJson(Map<String, dynamic> json) {
    return Nota(
      id: json['id'],
      erpId: json['erpId'],
      checkInId: json['checkInId'],
      lojaId: json['lojaId'],
      fornecedorId: json['fornecedorId'],
      fornecedorDesc: json['fornecedorDesc'],
      numPedCompra: json['numPedCompra'],
      chaveNf: json['chaveNf'],
      numNf: json['numNf'],
      serieNf: json['serieNf'],
      status: json['status'],
      statusDesc: json['statusDesc'],
      dtEmissao: json['dtEmissao'],
      dtEntrada: json['dtEntrada'],
      dtCadastro: json['dtCadastro'],
      valorTotal: json['valorTotal'].toDouble(),
      excluida: json['excluida'],
    );
  }
}
