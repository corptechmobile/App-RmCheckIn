import 'dart:convert';

import 'package:rmcheckin/app/const/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> registrarUser({
  required String cpf,
  required String? email,
  required String telefone,
  required String tipoValidacao,
}) async {
  var url = Uri.parse(ConstsApi.registrarUser);
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
      'Accept-Charset': 'utf-8',
    },
    body: jsonEncode(
      <String, dynamic>{
        'email': email,
        'cpf': cpf,
        'telefone': telefone,
        'tipoValidacao': tipoValidacao,
      },
    ),
  );
  print(response.body);
  if (response.statusCode == 200) {
    return json.decode(utf8.decode(response.bodyBytes));
  } else {
    throw Exception('Erro ao verificar o token');
  }
}
