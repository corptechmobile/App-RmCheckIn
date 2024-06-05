// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:rmcheckin/app/models/model.dart';
import 'package:rmcheckin/app/models/nf_compra.dart';

class CheckInDto {
  final int id;
  final int veiculoId;
  final int veiculoTipoId;
  final int motoristaId;
  final String fornecedorDesc;
  final int grupoEmpresarialId;
  final String grupoEmpresarialDesc;
  final int lojaId;
  final int fornecedorId;
  final String veiculoTipoDesc;
  final String motoristaNome;
  final String lojaDesc;
  final int prioridade;
  final String? dtChegada;
  final String? dtPrevisaoEntrada;
  final String? dtEntrada;
  final String? dtInicio;
  final String? dtTermino;
  final String? dtCancelado;
  final String status;
  final String statusDesc;
  final String? docaDesc;
  final int? docaId;
  List<NFCompra> notas;
  CheckInDto({
    required this.id,
    required this.veiculoId,
    required this.veiculoTipoId,
    required this.motoristaId,
    required this.fornecedorDesc,
    required this.grupoEmpresarialId,
    required this.grupoEmpresarialDesc,
    required this.lojaId,
    required this.fornecedorId,
    required this.veiculoTipoDesc,
    required this.motoristaNome,
    required this.lojaDesc,
    required this.prioridade,
    required this.dtChegada,
    required this.dtPrevisaoEntrada,
    required this.dtEntrada,
    required this.dtInicio,
    required this.dtTermino,
    required this.dtCancelado,
    required this.status,
    required this.statusDesc,
    required this.docaDesc,
    required this.docaId,
    required this.notas,
  });

  factory CheckInDto.fromJsonDecoded(Map<String, dynamic> checkinJsonDecoded) {
    List<dynamic> notasJson = checkinJsonDecoded['notas'];
    List<NFCompra> notasFiscais = [];

    for (var notaJson in notasJson) {
      if (notaJson is Map<String, dynamic>) {
        notasFiscais.add(
          NFCompra(
            id: notaJson['id'],
            statusDesc: notaJson['statusDesc'],
            chaveNf: notaJson['chaveNf'],
            fornecedorDesc: notaJson['fornecedorDesc'],
            valorTotal: notaJson['valorTotal'],
            checkInId: notaJson['checkInId'],
            numNf: notaJson['numNf'],
            serieNf: notaJson['serieNf'],
            dtCadastro: notaJson['dtCadastro'],
            status: notaJson['status'],
            dtEntrada: notaJson['dtEntrada'],
            erpId: notaJson['erpId'],
            dtEmissao: notaJson['dtEmissao'],
            excluida: notaJson['excluida'],
            fornecedorId: notaJson['fornecedorId'],
            lojaId: notaJson['lojaId'],
          ),
        );
      }
    }
    CheckInDto dataDto = CheckInDto(
        fornecedorDesc: checkinJsonDecoded['fornecedorDesc'],
        grupoEmpresarialId: checkinJsonDecoded['grupoEmpresarialId'],
        grupoEmpresarialDesc: checkinJsonDecoded['grupoEmpresarialDesc'],
        lojaId: checkinJsonDecoded['lojaId'],
        fornecedorId: checkinJsonDecoded['fornecedorId'],
        motoristaId: checkinJsonDecoded['motoristaId'],
        dtChegada: checkinJsonDecoded['dtChegada'],
        dtPrevisaoEntrada: checkinJsonDecoded['dtPrevisaoEntrada'],
        dtEntrada: checkinJsonDecoded['dtEntrada'],
        dtInicio: checkinJsonDecoded['dtInicio'],
        dtTermino: checkinJsonDecoded['dtTermino'],
        dtCancelado: checkinJsonDecoded['dtCancelado'],
        status: checkinJsonDecoded['status'],
        statusDesc: checkinJsonDecoded['statusDesc'],
        docaDesc: checkinJsonDecoded['docaDesc'],
        docaId: checkinJsonDecoded['docaId'],
        notas: notasFiscais,
        id: checkinJsonDecoded['id'],
        lojaDesc: checkinJsonDecoded['lojaDesc'],
        motoristaNome: checkinJsonDecoded['motoristaNome'],
        prioridade: checkinJsonDecoded['prioridade'],
        veiculoId: checkinJsonDecoded['veiculoId'],
        veiculoTipoDesc: checkinJsonDecoded['veiculoTipoDesc'],
        veiculoTipoId: checkinJsonDecoded['veiculoTipoId']);

    return dataDto;
  }

  static Future<Map<String, dynamic>> getPreSalvarDto(
    CheckInDto registrarNf,
  ) async {
    var checkin = Checkin(
      docaDesc: registrarNf.docaDesc,
      docaId: registrarNf.docaId,
      fornecedorDesc: registrarNf.fornecedorDesc,
      grupoEmpresarialId: registrarNf.grupoEmpresarialId,
      grupoEmpresarialDesc: registrarNf.grupoEmpresarialDesc,
      lojaId: registrarNf.lojaId,
      fornecedorId: registrarNf.fornecedorId,
      motoristaId: registrarNf.motoristaId,
      dtChegada: DateTime.tryParse(registrarNf.dtChegada ?? ''),
      dtPrevisaoEntrada: DateTime.tryParse(registrarNf.dtPrevisaoEntrada ?? ''),
      dtEntrada: DateTime.tryParse(registrarNf.dtEntrada ?? ''),
      dtInicio: DateTime.tryParse(registrarNf.dtInicio ?? ''),
      dtTermino: DateTime.tryParse(registrarNf.dtTermino ?? ''),
      dtCancelado: DateTime.tryParse(registrarNf.dtCancelado ?? ''),
      status: registrarNf.status,
      statusDesc: registrarNf.statusDesc,
      id: registrarNf.id,
      lojaDesc: registrarNf.lojaDesc,
      motoristaNome: registrarNf.motoristaNome,
      prioridade: registrarNf.prioridade,
      veiculoTipoDesc: registrarNf.veiculoTipoDesc,
      veiculoTipoId: registrarNf.veiculoTipoId,
    );

    List<Nf_compra> notas = List<Nf_compra>.empty(growable: true);
    for (var nota in registrarNf.notas) {
      notas.add(
        Nf_compra(
          chaveNf: nota.chaveNf,
          fornecedorDesc: nota.fornecedorDesc,
          valorTotal: nota.valorTotal,
          statusDesc: nota.statusDesc,
          numNf: nota.numNf,
          serieNf: nota.serieNf,
          dtCadastro: nota.dtCadastro,
          status: nota.status,
          dtEntrada: DateTime.tryParse(nota.dtEntrada),
          erpId: nota.erpId,
          id: nota.id,
          excluida: nota.excluida,
          lojaId: nota.lojaId,
          dtEmissao: nota.dtEmissao,
          fornecedorId: nota.fornecedorId,
          id_checkin: registrarNf.id,
        ),
      );
    }

    return {
      "checkin": checkin,
      "nf_compra": notas,
    };
  }

  static Future<void> salvarDto(CheckInDto registrarNf) async {
    late Checkin checkin;
    late List<Nf_compra> notas;

    await getPreSalvarDto(registrarNf).then((value) {
      checkin = value["checkin"];
      notas = value["nf_compra"];
    });

    await checkin.save();

    for (var nota in notas) {
      await nota.save();
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fornecedorDesc': fornecedorDesc,
      'grupoEmpresarialId': grupoEmpresarialId,
      'grupoEmpresarialDesc': grupoEmpresarialDesc,
      'lojaId': lojaId,
      'fornecedorId': fornecedorId,
      'motoristaId': motoristaId,
      'dtChegada': dtChegada,
      'dtPrevisaoEntrada': dtPrevisaoEntrada,
      'dtEntrada': dtEntrada,
      'dtInicio': dtInicio,
      'dtTermino': dtTermino,
      'dtCancelado': dtCancelado,
      'status': status,
      'statusDesc': statusDesc,
    };
  }

  factory CheckInDto.fromMap(Map<String, dynamic> map) {
    return CheckInDto(
      fornecedorDesc: map['fornecedorDesc'] as String,
      grupoEmpresarialId: map['grupoEmpresarialId'],
      grupoEmpresarialDesc: map['grupoEmpresarialDesc'] ?? '',
      lojaId: map['lojaId'] ?? '',
      fornecedorId: map['fornecedorId'] ?? '',
      motoristaId: map['motoristaId'] ?? '',
      dtChegada: map['dtChegada'] ?? '',
      dtPrevisaoEntrada: map['dtPrevisaoEntrada'] ?? '',
      dtEntrada: map['dtEntrada'] ?? '',
      dtInicio: map['dtInicio'] ?? '',
      dtTermino: map['dtTermino'] ?? '',
      dtCancelado: map['dtCancelado'] ?? '',
      status: map['status'] ?? '',
      statusDesc: map['statusDesc'] ?? '',
      notas: map['notasFiscaais'],
      docaDesc: map['docaDesc'],
      docaId: map['docaId'],
      id: map['id'],
      lojaDesc: map['lojaDesc'],
      motoristaNome: map['motoristaNome'],
      prioridade: map['prioridade'],
      veiculoId: map['veiculoId'],
      veiculoTipoDesc: map['veiculoTipoDesc'],
      veiculoTipoId: map['veiculoTipoId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckInDto.fromJson(String source) =>
      CheckInDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NFCompra(fornecedorDesc: $fornecedorDesc, grupoEmpresarialId: $grupoEmpresarialId, grupoEmpresarialDesc: $grupoEmpresarialDesc, lojaId: $lojaId, fornecedorId: $fornecedorId, motoristaId: $motoristaId, dtChegada: $dtChegada, dtPrevisaoEntrada: $dtPrevisaoEntrada, dtEntrada: $dtEntrada, dtInicio: $dtInicio, dtTermino: $dtTermino, dtCancelado: $dtCancelado, status: $status, statusDesc: $statusDesc)';
  }

  @override
  bool operator ==(covariant CheckInDto other) {
    if (identical(this, other)) return true;

    return other.fornecedorDesc == fornecedorDesc &&
        other.grupoEmpresarialId == grupoEmpresarialId &&
        other.grupoEmpresarialDesc == grupoEmpresarialDesc &&
        other.lojaId == lojaId &&
        other.fornecedorId == fornecedorId &&
        other.motoristaId == motoristaId &&
        other.dtChegada == dtChegada &&
        other.dtPrevisaoEntrada == dtPrevisaoEntrada &&
        other.dtEntrada == dtEntrada &&
        other.dtInicio == dtInicio &&
        other.dtTermino == dtTermino &&
        other.dtCancelado == dtCancelado &&
        other.status == status &&
        other.statusDesc == statusDesc;
  }

  @override
  int get hashCode {
    return fornecedorDesc.hashCode ^
        grupoEmpresarialId.hashCode ^
        grupoEmpresarialDesc.hashCode ^
        lojaId.hashCode ^
        fornecedorId.hashCode ^
        motoristaId.hashCode ^
        dtChegada.hashCode ^
        dtPrevisaoEntrada.hashCode ^
        dtEntrada.hashCode ^
        dtInicio.hashCode ^
        dtTermino.hashCode ^
        dtCancelado.hashCode ^
        status.hashCode ^
        statusDesc.hashCode;
  }
}
