import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> redefineUser({required String nome, required String email, required String cpf, required String telefone,required String foto}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final result = sharedPreferences.getString('data');
  Motorista user;
  if (jsonDecode(result!).containsKey('data')) {
    user = Motorista.fromMap(jsonDecode(result)['data']);
  } else {
    user = Motorista.fromMap(jsonDecode(result));
  }
  final response = await http.post(
    Uri.parse(ConstsApi.redefinirDados),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'email': user.email,
      'nome': nome,
      'cpf': user.cpf,
      'telefone': telefone,
    }),
  );
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    if (responseData["data"] == "ok") {
      final newUser = Motorista(
        id: user.id,
        cpf: cpf,
        nome: nome,
        email: email,
        telefone: telefone,
        foto: foto,
        status: user.status,
        redes: user.redes,
        veiculos: user.veiculos,
      );

      var jsonData = newUser.toJson();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('data', jsonData);
      return true;
    } else {
      print("Errors during user data update: ${responseData['errors']}");
      return false;
    }
  } else {
    print("HTTP error during user data update: ${response.statusCode}");
    return false;
  }
}
