import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AlterarSenhaDataSorce {
  Future<bool> alterarSenhaService({required String passwordNew, required String passwordOld, required String cpf}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString('data');
    final user = Motorista.fromMap(jsonDecode(result!)['data']);
    var url = Uri.parse(ConstsApi.alterarSenha);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
      },
      body: jsonEncode(
        <String, String>{
          'cpf': user.cpf,
          'passwordNew': passwordNew,
          'passwordOld': passwordOld,
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
