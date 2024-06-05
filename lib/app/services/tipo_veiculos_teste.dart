import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';

// Função para registrar veículo do motorista
Future<void> registrarVeiculo({required String cpf, required String placa, required int tipoVeiculo}) async {
  final url = Uri.parse(ConstsApi.tipoVeiculo);

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode({
      'cpf': cpf,
      'placa': placa,
      'tipoVeiculo': tipoVeiculo,
    }),
  );

  if (response.statusCode == 200) {
    // Sucesso
    final responseData = jsonDecode(response.body);
    print('Registro do veículo realizado com sucesso: ${responseData['data']}');
  } else {
    // Erro
    final errorData = jsonDecode(response.body);
    print('Erro no registro do veículo: ${errorData['errors'][0]}');
  }
}

Future<void> obterTiposVeiculos() async {
  final url = Uri.parse(ConstsApi.tipoVeiculo);

  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
  );

  if (response.statusCode == 200) {
    // Sucesso
    final responseData = jsonDecode(response.body);
    final tiposVeiculos = responseData['data']['tipos'];

    print('Tipos de Veículos:');
    for (var tipo in tiposVeiculos) {
      print('ID: ${tipo['id']}, Descrição: ${tipo['descricao']}');
    }
  } else {
    // Erro
    final errorData = jsonDecode(response.body);
    print('Erro ao obter tipos de veículos: ${errorData['errors'][0]}');
  }
}
