import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';

class VerificarCpfService {
  Future<Map<String, dynamic>> login({
    required String cpf,
  }) async {
    var url = Uri.parse(ConstsApi.verificarCpf);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
        'Accept-Charset': 'utf-8',
      },
      body: jsonEncode(<String, String>{"cpf": cpf}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao verificar o token');
    }
  }
}
