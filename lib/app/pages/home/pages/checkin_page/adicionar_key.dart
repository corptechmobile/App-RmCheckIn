import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:rmcheckin/app/models/checkin_model.dart';
import 'package:rmcheckin/app/models/model.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/models/nf_compra.dart';
import 'package:rmcheckin/app/services/concluir_checkin_service.dart';
import 'package:rmcheckin/app/services/excluir_nf_service.dart';
import 'package:rmcheckin/app/services/registrar_checkin_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class AdicionarKey extends StatefulWidget {
  final int veiculoId;
  final int selectedLojaId;
  const AdicionarKey({
    Key? key,
    required this.veiculoId,
    required this.selectedLojaId,
  }) : super(key: key);

  @override
  State<AdicionarKey> createState() => _AdicionarKeyState();
}

class _AdicionarKeyState extends State<AdicionarKey> {
  List<NFCompra> notasFiscais = [];
  int? nfCompraId;
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  Motorista? user;
  bool loading = true;
  int? checkInId;

  Future<void> motoristaUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final result = sharedPreferences.getString("data");
    setState(() {
      user = Motorista.fromMap(jsonDecode(result!)["data"]);
    });
  }

  final TextEditingController nfController = TextEditingController();
  @override
  void initState() {
    super.initState();
    motoristaUser();

    print('ID da Loja Selecionada: ${widget.selectedLojaId}');
  }

  Future<void> _handleConcluirCheckin() async {
    try {
      var apiResponse =
          await concluirCheckin(cpf: user!.cpf, checkInId: checkInId!);
      if (apiResponse.containsKey('errors')) {
        var errors = apiResponse['errors'] as List<dynamic>;
        if (errors.isNotEmpty) {
          errorMessage = errors[0] as String;
        }
      } else {
        // Se não houver erros, prossiga com a lógica desejada
        _entregarNfsPortaria(context);
      }
    } catch (e) {
      // Trate possíveis exceções
      errorMessage = 'Erro ao concluir o Check-In';
    }
    setState(
        () {}); // Atualize o estado para refletir as alterações na interface
  }

  Future<void> _showDeleteAccountConfirmationDialog(
      BuildContext context) async {
    bool confirmDelete = false;
    bool isDeleteAccountChecked = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Leitura de notas fiscais',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 26,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Tem certeza que fez a leitura de todas as notas fiscais?',
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: isDeleteAccountChecked,
                        onChanged: (value) {
                          setState(() {
                            isDeleteAccountChecked = value ?? false;
                            confirmDelete = isDeleteAccountChecked;
                          });
                        },
                      ),
                      Text(
                        'Sim!',
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Cancelar',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                if (confirmDelete)
                  TextButton(
                    child: Text(
                      'Confirmar',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(
                          fontSize: 17,
                          color: darkBlueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      _handleConcluirCheckin();
                      _entregarNfsPortaria(context);
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _entregarNfsPortaria(BuildContext context) async {
    bool confirmDelete = false;
    bool isDeleteAccountChecked = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'AVISO!',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 26,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Entregue as Notas Fiscais na portaria para dar continuidade no recebimento!',
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Ok',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 17,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, '/checkin');
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double telaHeight = MediaQuery.of(context).size.height;
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    onPressedSearch() async {
      var registrarNf = await RegistrarLoja().registrarLoja(
        cpf: user!.cpf,
        lojaId: widget.selectedLojaId,
        veiculoId: widget.veiculoId,
        chaveNf: nfController.text,
      );

      if (registrarNf['success']) {
        CheckInDto? checkInDto = registrarNf['data'];
        if (checkInDto != null) {
          await MyDbModel().batchStart();
          CheckInDto.salvarDto(checkInDto);
          print(await MyDbModel().batchCommit());
          setState(() {
            notasFiscais = checkInDto.notas;
            checkInId = checkInDto.id;
            errorMessage = null;
            nfCompraId = checkInDto.id;
          });
          nfController.clear();
        }
      } else {
        setState(() {
          errorMessage = registrarNf['error'];
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: darkBlueColor,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/iconAppTop.png',
          fit: BoxFit.contain,
          height: 150,
          width: 150,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leitura de Chave de NF:',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                      color: darkBlueColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: telaHeight * 0.020,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: nfController,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Adicione a Chave da NF ",
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
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SimpleBarcodeScannerPage(
                              scanType: ScanType.barcode,
                            ),
                          ));

                      setState(() {
                        if (res is String && res != "-1") {
                          nfController.text = res;
                          onPressedSearch();
                        }
                      });
                      nfController.clear();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: onPressedSearch,
                  ),
                ],
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              SizedBox(
                height: telaHeight * 0.06,
              ),
              SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.50,
                      child: Container(
                        height: screenHeight * 0.50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: notasFiscais.length,
                          itemBuilder: (context, index) {
                            // ignore: unused_local_variable
                            String ultimosSeisNumeros = notasFiscais[index]
                                .chaveNf
                                .substring(
                                    notasFiscais[index].chaveNf.length - 6);
                            bool showFornecedorName = index == 0 ||
                                notasFiscais[index].fornecedorDesc !=
                                    notasFiscais[index - 1].fornecedorDesc;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (showFornecedorName)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 4.0),
                                    child: Text(
                                      // ignore: unnecessary_string_interpolations
                                      '${notasFiscais[index].fornecedorDesc}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                Card(
                                  elevation: 2.0,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(
                                        'NF: ${notasFiscais[index].numNf}-${notasFiscais[index].serieNf}'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Status: ${notasFiscais[index].statusDesc}'),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: (Colors.red),
                                      ),
                                      onPressed: () async {
                                        try {
                                          apiResponse =
                                              await ExcluirNF().excluirNf(
                                            cpf: user!.cpf,
                                            checkInId: checkInId!,
                                            nfCompraId: notasFiscais[index].id,
                                          );
                                          if (apiResponse!['data'] == 'ok') {
                                            await Nf_compra()
                                                .select()
                                                .where('id = ${notasFiscais}')                                              
                                                .delete();
                                            setState(() {
                                              notasFiscais.removeAt(index);
                                              
                                            });
                                          } else {
                                            setState(() {
                                              errorMessage =
                                                  apiResponse!['errors'][0];
                                            });
                                          }
                                        } catch (e) {
                                          // Trate possíveis erros
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: telaHeight * 0.001,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: yellowColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: notasFiscais.isNotEmpty
                    ? () async {
                        _showDeleteAccountConfirmationDialog(context);
                      }
                    : null, // Desabilita o botão se a lista estiver vazia
                child: const Text('Finalizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
