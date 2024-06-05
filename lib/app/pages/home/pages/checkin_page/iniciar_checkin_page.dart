import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/const/const.dart';
import 'package:rmcheckin/app/models/loja_model.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/pages/home/pages/checkin_page/selecionar_veiculo_page.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IniciarCheckin extends StatefulWidget {
  const IniciarCheckin({super.key});

  @override
  State<IniciarCheckin> createState() => _IniciarCheckinState();
}

class _IniciarCheckinState extends State<IniciarCheckin> {
  Motorista? user;

  motoristaUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString("data");
    if (jsonDecode(result!).containsKey('data')) {
      user = Motorista.fromMap(jsonDecode(result)['data']);
    } else {
      user = Motorista.fromMap(jsonDecode(result));
    }
    setState(() {});
  }

  pegarPosicao() async {
    Position posicao = await Geolocator.getCurrentPosition();
    print(posicao);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await motoristaUser();
        setState(() {
          _isLoading = true;
        });
        await _realizarCheckin();
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  Position? _currentLocation;
  late bool servicePermision = false;
  late LocationPermission permission;
  int? lojaSelecionadaId;
  String _currentAdress = '';
  _getAdressFromCordenadas() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAdress = "${place.locality}, ${place.country}";
      });
    } catch (e) {
      if (e is PlatformException) {
        print('Erro de plataforma: ${e.message}');
      } else {
        print('Erro durante a geocodificação: $e');
      }
    }
  }

  bool _isLoading = false;
  List<Loja> lojas = [];

  Future<Position> _getCurrentLocation() async {
    servicePermision = await Geolocator.isLocationServiceEnabled();
    if (!servicePermision) {
      print('service permission');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  String errorMessage = '';

  Future<void> _realizarCheckin() async {
    try {
      _currentLocation = await _getCurrentLocation();
      await _getAdressFromCordenadas();
      List<Loja> lojasResult = await realizarCheckin(cpf: user!.cpf, latitude: _currentLocation!.latitude, longitude: _currentLocation!.longitude);

      if (lojasResult.isNotEmpty) {
        setState(() {
          lojas = lojasResult;
        });
      } else {
        setState(() {
          errorMessage = 'Não há lojas próximas.';
        });
      }
      print("${_currentLocation}");
    } catch (e) {
      print('Erro durante o check-in: $e');
    }
  }

  Future<List<Loja>> realizarCheckin({required String cpf, required double latitude, required double longitude}) async {
    try {
      final url = Uri.parse(ConstsApi.lojasCheckin);

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'authorization': ConstsApi.basicAuth,
          'Accept-Charset': 'utf-8',
        },
        body: jsonEncode({
          'cpf': user!.cpf,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        if (responseData['data'] != null) {
          List<Loja> lojas = List<Loja>.from(responseData['data']['lojas'].map((loja) => Loja.fromJson(loja)));
          return lojas;
        } else {
          final errors = responseData['errors'] as List;
          errorMessage = 'Erro na chamada da API: ${errors.join(", ")}';
          return [];
        }
      } else {
        errorMessage = 'Erro no check-in: ${response.statusCode}';
        return [];
      }
    } catch (e) {
      errorMessage = 'Erro na chamada da API: $e';
      return [];
    }
  }
/*   var latitude = -8.0614775217; 
  var longitude = -34.9250941759; */
  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    String nomeCompleto = user?.nome ?? '';
    List<String> partesDoNome = nomeCompleto.split(' ');
    String primeiroNome = partesDoNome.isNotEmpty ? partesDoNome[0] : '';
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: darkBlueColor,
        title: Image.asset(
          'assets/iconAppTop.png',
          fit: BoxFit.contain,
          height: 150,
          width: 150,
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Iniciando novo Checkin',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(fontSize: 24, color: darkBlueColor, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: telaHeight * 0.015),
              Text('$primeiroNome, Selecione a Loja para voce fazer Checkin:',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold),
                  )),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              SizedBox(
                height: 10,
              ),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: lojas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(lojas[index].descricao),
                      subtitle: Text(lojas[index].grupoEmpresarialDesc),
                      trailing: Radio(
                        value: lojas[index].id,
                        groupValue: lojaSelecionadaId,
                        onChanged: (int? value) {
                          setState(() {
                            lojaSelecionadaId = value;
                            // Aqui, você pode adicionar lógica adicional se necessário
                            print("ID da Loja Selecionada: $value");
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              if (lojaSelecionadaId != null)
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SelecionarVeiculo(selectedLojaId: lojaSelecionadaId!)));
                    },
                    child: const Text('Confirmar Seleção'),
                  ),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}