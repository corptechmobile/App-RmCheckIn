import 'dart:convert';

import 'package:rmcheckin/app/const/const.dart';
import 'package:http/http.dart' as http;

Future<bool> finalizarRegistro({
  required String nome,
  required String cpf,
  required String? email,
  required String password,
  required String telefone,
}) async {
  var url = Uri.parse(ConstsApi.finalizarRegistro);
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(
      <String, dynamic>{
        'email': email,
        'cpf': cpf,
        'telefone': telefone,
        'nome': nome,
        'password': password,
      },
    ),
  );
  print(response.body);
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
