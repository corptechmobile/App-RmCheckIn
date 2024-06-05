import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/const/const.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/pages/home/pages/checkin_page/selecionar_veiculo_page.dart';
import 'package:rmcheckin/app/services/registrar_veiculo_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AtualizarCaminhao extends StatefulWidget {
  final int selectedLojaId;
  final Function update;
  const AtualizarCaminhao({
    super.key,
    required this.selectedLojaId,
    required this.update,
  });

  @override
  State<AtualizarCaminhao> createState() => _AtualizarCaminhaoState();
}

class _AtualizarCaminhaoState extends State<AtualizarCaminhao> {
  bool _showPassword = false;

  final TextEditingController placaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Motorista? user;
  bool isLoading = false;
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

  @override
  void initState() {
    super.initState();
    motoristaUser();
    obterTiposVeiculos().then((tipos) {
      setState(() {
        tiposVeiculos = tipos;
      });
    });
  }

  int? selectedTipoVeiculo;
  List<Map<String, dynamic>> tiposVeiculos = [];

  Future<List<Map<String, dynamic>>> obterTiposVeiculos() async {
    final url = Uri.parse(ConstsApi.tipoVeiculo);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'authorization': ConstsApi.basicAuth,
        'Accept-Charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return List<Map<String, dynamic>>.from(responseData['data']['tipos']);
    } else {
      return [];
      print('deu erro');
    }
  }

  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: telaHeight * 0.03,
                ),
                Text(
                  'Adicionar caminhão',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(color: darkBlueColor, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    'Placa do caminhao',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: placaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite uma placa valída';
                    }
                    return null;
                  },
                  inputFormatters: [
                    PlacaVeiculoInputFormatter(),
                  ],
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Digite a placa do caminhao",
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    'Tipo do caminhao',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DropdownButtonFormField<int>(
                  value: selectedTipoVeiculo,
                  onChanged: (value) {
                    setState(() {
                      selectedTipoVeiculo = value;
                    });
                  },
                  items: tiposVeiculos.map((tipo) {
                    return DropdownMenuItem<int>(
                      value: tipo['id'],
                      child: Text(
                        tipo['descricao'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  hint: const Text(
                    'Selecione o tipo de veículo',
                    style: TextStyle(fontSize: 16),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 36.0,
                  elevation: 16,
                  style: TextStyle(
                    color: darkBlueColor,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.09,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellowColor,
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
           try {
  await registrarVeiculo(
    cpf: user!.cpf,
    placa: placaController.text,
    tipoVeiculo: selectedTipoVeiculo!,
  ).then((value) {
    widget.update(); // Chama a função de atualização ao adicionar o veículo
    Navigator.pop(context); // Volta para a tela anterior
  });
} catch (e) {
  print('Error registering vehicle: $e');
  // Handle error (show a snackbar, display an error message, etc.)
}
                              }
                            },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              "Adicionar",
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
