
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';


Future<bool> alterarSenhaAuth({
  required String cpf,
  required String passwordNew,
}) async {
  var url = Uri.parse(ConstsApi.alerarSenhaAuthEsqueci);
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(
      <String, dynamic>{
        'cpf': cpf,
        'passwordNew': passwordNew,
       
      },
    ),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    print('Deu tudo certo no esqueci minha senha');
    print(response.body);

    return true;
  } else {
    print('Erro na chamada da API: ${response.statusCode}');
    return false;
  }
}
