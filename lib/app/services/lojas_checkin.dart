import 'dart:convert';

import 'package:rmcheckin/app/const/const.dart';

import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> registrarUser({
  required String cpf,
  required String latitude,
  required String longitude,
}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final result = sharedPreferences.getString('data');
  final user = Motorista.fromMap(jsonDecode(result!)['data']);
  var url = Uri.parse(ConstsApi.registrarUser);
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(
      <String, String>{
        'email': user.cpf,
        'latitude': latitude,
        'longitude': longitude,
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
