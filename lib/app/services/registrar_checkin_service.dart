import 'dart:convert';

import 'package:rmcheckin/app/const/const.dart';
import 'package:rmcheckin/app/models/checkin_model.dart';
import 'package:rmcheckin/app/models/grupoempresario_model.dart';
import 'package:rmcheckin/app/models/nf_compra.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegistrarLoja {
  Future<Map<String, dynamic>> registrarLoja({
    required String cpf,
    required int lojaId,
    required int veiculoId,
    required String chaveNf,
  }) async {
    var url = Uri.parse(ConstsApi.registrarCheckin);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
        'Accept-Charset': 'utf-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "cpf": cpf,
          "lojaId": lojaId,
          "veiculoId": veiculoId,
          "chaveNf": chaveNf,
        },
      ),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseBody.containsKey('data') && responseBody['data'] != null) {
        return {'success': true, 'data': CheckInDto.fromJsonDecoded(responseBody['data'])};
      } else {
        if (responseBody.containsKey('errors') && responseBody['errors'] != null && responseBody['errors'].isNotEmpty) {
          // Extracting the first error message
          String errorMessage = responseBody['errors'][0];
          return {'success': false, 'error': '$errorMessage'};
        } else {
          return {'success': false, 'error': 'Erro ao registrar o Check-In: Resposta da API inválida'};
        }
      }
    } else {
      return {'success': false, 'error': 'Erro ao registrar o Check-In: ${response.body}'};
    }
  }
}
