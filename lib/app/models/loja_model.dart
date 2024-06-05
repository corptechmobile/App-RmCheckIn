class Loja {
  final int id;
  final String descricao;
  final int grupoEmpresarialId;
  final String grupoEmpresarialDesc;
  final double latitude;
  final double longitude;
  bool selecionada;

  Loja({
    required this.id,
    required this.descricao,
    required this.grupoEmpresarialId,
    required this.grupoEmpresarialDesc,
    required this.latitude,
    required this.longitude,
    this.selecionada = false,
  });

  factory Loja.fromJson(Map<String, dynamic> json) {
    return Loja(
      id: json['id'],
      descricao: json['descricao'],
      grupoEmpresarialId: json['grupoEmpresarialId'],
      grupoEmpresarialDesc: json['grupoEmpresarialDesc'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
