import 'dart:convert';

import 'package:rmcheckin/app/const/const.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>>concluirCheckin({
  required String cpf,
  required int checkInId,
}) async {
  var url = Uri.parse(ConstsApi.concluirCheckin);
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(
      <String, dynamic>{'cpf': cpf, 'checkInId': checkInId},
    ),
  );
   if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro ao verificar o token');
    }
  }
