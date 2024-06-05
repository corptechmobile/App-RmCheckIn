// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RedeAuthModel {
  int id;
  String descricao;
  RedeAuthModel({
    required this.id,
    required this.descricao,
  });

  RedeAuthModel copyWith({
    int? id,
    String? descricao,
  }) {
    return RedeAuthModel(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'descricao': descricao,
    };
  }

  factory RedeAuthModel.fromMap(Map<String, dynamic> map) {
    return RedeAuthModel(
      id: map['id'] ?? 0,
      descricao: map['descricao'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RedeAuthModel.fromJson(String source) => RedeAuthModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RedeAuthModel(id: $id, descricao: $descricao)';

  @override
  bool operator ==(covariant RedeAuthModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.descricao == descricao;
  }

  @override
  int get hashCode => id.hashCode ^ descricao.hashCode;
}
