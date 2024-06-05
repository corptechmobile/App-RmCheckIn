import 'dart:convert';
import 'package:rmcheckin/app/const/const.dart';
import 'package:rmcheckin/app/models/checkin_model.dart';
import 'package:rmcheckin/app/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
Future<int> login(String cpf, String password) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var url = Uri.parse(ConstsApi.motoristaAuth);
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
    },
    body: jsonEncode(<String, String>{
      'cpf': cpf,
      'password': password,
    }),
  );

  print(response.body);

  if (response.statusCode == 200) {
    print(response.body);
    await sharedPreferences.setString("data", utf8.decode(response.bodyBytes));

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    var responseJsonData = responseJson['data'];

    await MyDbModel().batchStart();

    for (var checkin in responseJsonData['checkins']) {
      await CheckInDto.salvarDto(
        CheckInDto.fromJsonDecoded(checkin),
      );
    }

    await MyDbModel().batchCommit();

    return response.statusCode;
  } else if (response.statusCode == 404) {
    return response.statusCode;
  } else if (response.statusCode == 401) {
    return response.statusCode;
  } else {
    return response.statusCode;
  }
}