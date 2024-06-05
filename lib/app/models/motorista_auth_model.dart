// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:rmcheckin/app/models/rede_auth_model.dart';
import 'package:rmcheckin/app/models/veiculo_auth_model.dart';

class Motorista {
  int id;
  String cpf;
  String nome;
  String email;
  String telefone;
  String foto;
  String status;
  List<RedeAuthModel> redes;
  List<VeiculoAuthModel> veiculos;

  Motorista({
    required this.id,
    required this.cpf,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.foto,
    required this.status,
    required this.redes,
    required this.veiculos,
  });

  Motorista copyWith({
    int? id,
    String? cpf,
    String? nome,
    String? email,
    String? telefone,
    String? foto,
    String? status,
    List<RedeAuthModel>? redes,
    List<VeiculoAuthModel>? veiculos,
  }) {
    return Motorista(
      id: id ?? this.id,
      cpf: cpf ?? this.cpf,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      foto: foto ?? this.foto,
      status: status ?? this.status,
      redes: redes ?? this.redes,
      veiculos: veiculos ?? this.veiculos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cpf': cpf,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'foto': foto,
      'status': status,
      'redes': redes.map((x) => x.toMap()).toList(),
      'veiculos': veiculos.map((x) => x.toMap()).toList(),
    };
  }

  factory Motorista.fromMap(Map<String, dynamic> map) {
    return Motorista(
      id: map['id'] ?? 0,
      cpf: map['cpf'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      foto: map['foto'] ?? '',
      status: map['status'] ?? '',
      redes: map['redes'] != null
          ? List<RedeAuthModel>.from(
              (map['redes']).map<RedeAuthModel>(
                (x) => RedeAuthModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : List<RedeAuthModel>.empty(),
      veiculos: List<VeiculoAuthModel>.from(
        (map['veiculos'] as List<dynamic>? ?? []).map<VeiculoAuthModel>(
          (x) => VeiculoAuthModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Motorista.fromJson(String source) => Motorista.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Motorista(id: $id, cpf: $cpf, nome: $nome, email: $email, telefone: $telefone, foto: $foto, status: $status, redes: $redes, veiculos: $veiculos)';
  }

  @override
  bool operator ==(covariant Motorista other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.cpf == cpf &&
        other.nome == nome &&
        other.email == email &&
        other.telefone == telefone &&
        other.foto == foto &&
        other.status == status &&
        listEquals(other.redes, redes) &&
        listEquals(other.veiculos, veiculos);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        cpf.hashCode ^
        nome.hashCode ^
        email.hashCode ^
        telefone.hashCode ^
        foto.hashCode ^
        status.hashCode ^
        redes.hashCode ^
        veiculos.hashCode;
  }
}
