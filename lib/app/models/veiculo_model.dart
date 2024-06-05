class Veiculo {
  final String placa;
  final String tipoVeiculo;

  Veiculo({required this.placa, required this.tipoVeiculo});

  Map<String, dynamic> toJson() {
    return {
      'placa': placa,
      'tipo': tipoVeiculo,
    };
  }

  factory Veiculo.fromJson(Map<String, dynamic> json) {
    return Veiculo(
      placa: json['placa'],
      tipoVeiculo: json['tipo'],
    );
  }
}
