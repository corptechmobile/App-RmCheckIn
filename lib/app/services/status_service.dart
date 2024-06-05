import 'dart:convert';
import 'package:rmcheckin/app/const/const.dart';
import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/models/checkin_model.dart';
import 'package:rmcheckin/app/models/model.dart';

Future<List<Map<String, dynamic>>> statusCheckin({
  required String cpf,
  required List<int> checkInIds,
}) async {
  var url = Uri.parse(ConstsApi.statusService);
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': ConstsApi.basicAuth,
      'Accept-Charset': 'utf-8',
    },
    body: jsonEncode(
      <String, dynamic>{
        'cpf': cpf,
        'checkInIds': checkInIds,
      },
    ),
  );

  if (response.statusCode != 200) {
    print('Erro na chamada da API: ${response.statusCode}');
    return [];
  }

  final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes))['data'];

  List paraSalvar = List.empty(growable: true);

  for (var checkin in responseData) {
    var checkinStatus = CheckInDto.fromJsonDecoded(checkin);
    paraSalvar.add(await CheckInDto.getPreSalvarDto(checkinStatus));
  }

  List<Checkin> checkinsParaSalvar = List<Checkin>.empty(growable: true);
  List<Nf_compra> nf_comprasParaSalvar = List<Nf_compra>.empty(growable: true);
  for (var checkin in paraSalvar) {
    checkinsParaSalvar.add(checkin["checkin"]);
    nf_comprasParaSalvar.addAll(checkin["nf_compra"]);
  }

  var notificar = List<Map<String, dynamic>>.empty(growable: true);
  await MyDbModel().batchStart();

  for (var checkin in checkinsParaSalvar) {
    if ((await Checkin().select().where("id = ${checkin.id}").toSingle())!.status != checkin.status) {
      notificar.add(checkin.toMap());
    }

    await Checkin().select().where("id = ${checkin.id}").update(
          checkin.toMap().map(
            (key, value) {
              if (value is DateTime) return MapEntry(key, (value).millisecondsSinceEpoch);
              if (value is bool) return MapEntry(key, value ? 1 : 0);

              return MapEntry(key, value);
            },
          ),
        );
    // await checkin.upsert();
  }

  for (var nf_compra in nf_comprasParaSalvar) {
    await Nf_compra().select().where("id = ${nf_compra.id}").update(nf_compra.toMap().map((key, value) {
          if (value is! DateTime) return MapEntry(key, value);

          return MapEntry(key, (value).millisecondsSinceEpoch);
        }));
    // await nf_compra.upsert();
  }

  await MyDbModel().batchCommit();

  return notificar;
}
