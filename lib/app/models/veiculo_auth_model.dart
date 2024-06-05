// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VeiculoAuthModel {
  int id;
  String tipoVeiculo;
  String placa;
  String foto;
  VeiculoAuthModel({
    required this.id,
    required this.tipoVeiculo,
    required this.placa,
    required this.foto,
  });

  VeiculoAuthModel copyWith({
    int? id,
    String? tipoVeiculo,
    String? placa,
    String? foto,
  }) {
    return VeiculoAuthModel(
      id: id ?? this.id,
      tipoVeiculo: tipoVeiculo ?? this.tipoVeiculo,
      placa: placa ?? this.placa,
      foto: foto ?? this.foto,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tipoVeiculo': tipoVeiculo,
      'placa': placa,
      'foto': foto,
    };
  }

  factory VeiculoAuthModel.fromMap(Map<String, dynamic> map) {
    return VeiculoAuthModel(
      id: map['id'] as int? ?? 0,
      tipoVeiculo: map['tipoVeiculo'] as String? ?? '',
      placa: map['placa'] as String? ?? '',
      foto: map['foto'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VeiculoAuthModel.fromJson(String source) => VeiculoAuthModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VeiculoAuthModel(id: $id, tipoVeiculo: $tipoVeiculo, placa: $placa, foto: $foto)';
  }

  @override
  bool operator ==(covariant VeiculoAuthModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.tipoVeiculo == tipoVeiculo && other.placa == placa && other.foto == foto;
  }

  @override
  int get hashCode {
    return id.hashCode ^ tipoVeiculo.hashCode ^ placa.hashCode ^ foto.hashCode;
  }
}
