import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';

class ExcluirNF {
  Future<Map<String, dynamic>> excluirNf({required String cpf, required int checkInId, required int nfCompraId}) async {
    var url = Uri.parse(ConstsApi.excluirNF);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, dynamic>{
          'cpf': cpf,
          'nfCompraId': nfCompraId,
          'checkInId': checkInId,
        },
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao verificar o token');
    }
  }
}
