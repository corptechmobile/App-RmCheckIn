import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';

class EsqueciSenhaDataSorceSMSValidarToken {
  Future<Map<String, dynamic>> esqueciSenhaService({required String cpf, required String token}) async {
    var url = Uri.parse(ConstsApi.esqueciMinhaSenhaToken);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{'cpf': cpf, 'token': token},
      ),
    );
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao verificar o token');
    }
  }
}
