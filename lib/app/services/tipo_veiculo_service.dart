/* import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';
import 'package:rmcheckin/app/models/tipo_veiculo.dart';
import 'package:rmcheckin/app/models/loja_model.dart';

class TipoVeiculoService {
  Future<List<TipoVeiculoModel>> tipoVeiculo() async {
    var url = Uri.parse(ConstsApi.tipoVeiculo);
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json;',
        'authorization': ConstsApi.basicAuth,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data']['tipos'];
      List<TipoVeiculoModel> tipos = data.map((item) {
        return TipoVeiculoModel(id: item['id'], descricao: item['descricao']);
      }).toList();

      return tipos;
    } else {
      print('Erro ao buscar tipos de veículos: ${response.statusCode}');
      throw Exception('Erro ao buscar tipos de veículos');
    }
  }
} */
