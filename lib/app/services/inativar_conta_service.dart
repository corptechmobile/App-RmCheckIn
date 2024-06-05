import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';

class DeixarUserInativo {
  Future<bool> deixarUserInativo({
    required String cpf,
  }) async {
    var url = Uri.parse(ConstsApi.inativarUser);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'email': cpf,
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['data'] == 'ok') {
        print('Sucesso');
        return true;
      } else {
        final errors = responseData['errors'];
        print('Erro: $errors');
        return false;
      }
    }
    return false;
  }
}
