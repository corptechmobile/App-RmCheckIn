// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rmcheckin/app/const/const.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/models/veiculo_auth_model.dart';
import 'package:rmcheckin/app/pages/home/pages/checkin_page/adicionar_key.dart';
import 'package:rmcheckin/app/pages/home/pages/checkin_page/atualizar_caminhao.dart';
import 'package:rmcheckin/app/services/registrar_veiculo_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelecionarVeiculo extends StatefulWidget {
  final int selectedLojaId;
  const SelecionarVeiculo({
    Key? key,
    required this.selectedLojaId,
  }) : super(key: key);

  @override
  State<SelecionarVeiculo> createState() => _SelecionarVeiculoState();
}

class _SelecionarVeiculoState extends State<SelecionarVeiculo> {
  bool primeiroItem = false;
  bool segundoItem = false;
  double opacity = 0.0;
  void desmarcarPrimeiroCheckbox() {
    setState(() {
      primeiroItem = false;
    });
  }

  VeiculoAuthModel? selectedVeiculo;
  bool isLoading = false;
  List<VeiculoAuthModel> veiculosSelecionados = [];
  Motorista? user;
  bool loading = true;
  bool loadingData = false;

  Future<void> motoristaUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString("data");
    if (result != null) {
      if (jsonDecode(result).containsKey('data')) {
        user = Motorista.fromMap(jsonDecode(result)['data']);
      } else {
        user = Motorista.fromMap(jsonDecode(result));
      }
    }
    setState(() {});
  }

  final TextEditingController placaController = TextEditingController();

  int? selectedTipoVeiculo;
  List<Map<String, dynamic>> tiposVeiculos = [];

  @override
  void initState() {
    super.initState();
    // update();
    motoristaUser();
 
      obterTiposVeiculos();
    
    print('ID da Loja Selecionada: ${widget.selectedLojaId}');
  }

  update() async {
    final result = await obterTiposVeiculos();
    setState(() {
      tiposVeiculos = result;
    });
  }

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              'Selecione o seu Veiculo:',
              style: GoogleFonts.dosis(
                textStyle: TextStyle(color: darkBlueColor, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: telaHeight * 0.01,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: user?.veiculos.length ?? 0,
                itemBuilder: (context, index) {
                  final veiculo = user?.veiculos[index];
                  return ListTile(
                    title: Text(veiculo?.tipoVeiculo ?? ''),
                    subtitle: Text(veiculo?.placa ?? ''),
                    leading: Radio(
                      value: veiculo,
                      groupValue: selectedVeiculo,
                      onChanged: (value) {
                        setState(() {
                          selectedVeiculo = value;
                          print('ID do Veículo Selecionado: ${value?.id}');
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                  ),
                  onPressed: () async {
          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AtualizarCaminhao(
      update: () async {
        await motoristaUser(); // Atualiza os dados do usuário
        await obterTiposVeiculos(); // Chama a API para obter os veículos atualizados
        setState(() {}); // Atualiza a interface
      },
      selectedLojaId: widget.selectedLojaId,
    ),
  ),
).then((value) async {
  await motoristaUser(); // Atualiza os dados do usuário quando a tela voltar
});
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Veiculos'),
                ),
              ],
            ),
            SizedBox(
              height: telaHeight * 0.06,
            ),
            Center(
              child: AnimatedOpacity(
                opacity: selectedVeiculo != null ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    if (selectedVeiculo != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdicionarKey(
                            selectedLojaId: widget.selectedLojaId,
                            veiculoId: selectedVeiculo!.id,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, escolha um veículo.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Continuar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
