import 'dart:convert';

import 'package:rmcheckin/app/const/const.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> registrarVeiculo({
  required String cpf,
  required String placa,
  required int tipoVeiculo,
}) async {
  var url = Uri.parse(ConstsApi.registrarVeiculo);
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(
      <String, dynamic>{
        'cpf': cpf,
        'placa': placa,
        'tipoVeiculo': tipoVeiculo,
      },
    ),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    print('Deu tudo certo no cadastro');
    print(response.body);

    return true;
  } else {
    print('Erro na chamada da API: ${response.statusCode}');
    return false;
  }
}
