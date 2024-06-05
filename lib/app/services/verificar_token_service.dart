import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';

class VerificarTokenService {
  Future<Map<String, dynamic>> verificarToken(
    String telefone,
    String token,
  ) async {
    var url = Uri.parse(ConstsApi.verificarToken);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
        'Accept-Charset': 'utf-8',
      },
      body: jsonEncode(
        <String, String>{"telefone": telefone, "token": token},
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao verificar o token');
    }
  }
}
