import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rmcheckin/app/models/checkin_model.dart';
import 'package:rmcheckin/app/models/model.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/models/nf_compra.dart';
import 'package:rmcheckin/app/pages/home/pages/checkin_page/iniciar_checkin_page.dart';
import 'package:rmcheckin/app/pages/home/pages/telateste.dart';
import 'package:rmcheckin/app/services/status_service.dart';
import 'package:rmcheckin/app/shared/theme/nfcompra_status_enum.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  @override
  Motorista? user;
  late Timer _timer;
  bool isDockAvailable = true;
  bool isLoading = true;
  List<CheckInDto> checkIns = [];
  List<NFCompra> notas = [];
  bool loading = false;
  Map<String, dynamic>? dataInfo;
  String dataAtual = '';
  List<Checkin>? checkinsSalvos;
  List<Nf_compra>? nfCompraSalvos;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await MyDbModel().initializeDB();
        await _motoristaUser();
        await apagarCheckinsAntigos();

        await atualizarTela30s();
        setState(() {});
      },
    );
  }

  _motoristaUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = await sharedPreferences.getString("data");
    if (jsonDecode(result!).containsKey('data')) {
      user = Motorista.fromMap(jsonDecode(result)['data']);
    } else {
      user = Motorista.fromMap(jsonDecode(result));
    }
    if (user?.foto != '') {
      setState(() {});
      await atualizarTela30s();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaCadastroFoto(),
        ),
      );
    }
  }

  Future<void> atualizarTela30s() async {
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) async {
        if (!loading) {
          setState(() {
            isLoading = true;
          });

          var listCheckins = (await Checkin().select().toList())
              .map(
                (e) => e.id!,
              )
              .toList();

          await statusCheckin(
            cpf: user?.cpf ?? '',
            checkInIds: listCheckins,
          );

          await Checkin().select().toList().then(
            (value) {
              setState(() {
                checkinsSalvos = value;
                isLoading = false;
              });
            },
          );
          await Future.delayed(const Duration(seconds: 30));
        }
      },
    );
  }

  Future<void> pegarIdNf(checkInId) async {
    await Nf_compra().select().id_checkin.equals(checkInId).toList().then(
      (value) {
        setState(() {
          nfCompraSalvos = value;
        });
      },
    );
  }

  String calcularDiferencaHorasMinutos(DateTime dtChegada, DateTime? dtEntrada) {
    try {
      Duration diff;
      int horas = 0;
      int minutos = 0;
      if (dtEntrada == null) {
        diff = DateTime.now().difference(dtChegada);
        horas = diff.inHours;
        minutos = diff.inMinutes.remainder(60);
      } else {
        diff = dtEntrada.difference(dtChegada);
        horas = diff.inHours;
        minutos = diff.inMinutes.remainder(60);
      }

      if (horas == 0) {
        return '$minutos minutos';
      } else {
        return '$horas horas e $minutos minutos';
      }
    } catch (e) {
      return '';
    }
  }

  String formatarDataChegada(String? dtChegada) {
    try {
      if (dtChegada == null || dtChegada.isEmpty) {
        return 'Data não disponível';
      }

      DateTime dataChegada = DateTime.parse(dtChegada);
      DateTime dataAtual = DateTime.now();

      if (dataChegada.year == dataAtual.year && dataChegada.month == dataAtual.month && dataChegada.day == dataAtual.day) {
        return DateFormat('HH:mm').format(dataChegada);
      } else {
        return DateFormat('dd/MM/yyyy HH:mm').format(dataChegada);
      }
    } catch (e) {
      return 'Erro ao formatar data';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    Motorista? user = this.user;
    String nomeCompleto = user?.nome ?? "";
    List<String> partesDoNome = nomeCompleto.split(' ');
    String primeiroNome = partesDoNome.isNotEmpty ? partesDoNome[0] : '';
    if (checkinsSalvos == null) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, $primeiroNome',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(fontSize: 26, color: darkBlueColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                    ),
                    onPressed: () async {
                      _timer.cancel();

                      await Navigator.push(context, MaterialPageRoute(builder: (context) => const IniciarCheckin()));

                      atualizarTela30s();
                    },
                    child: Text(
                      'Iniciar um novo Checkin',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellowColor,
                      ),
                      onPressed: () async {
                        _timer.cancel();
                        atualizarTela30s();
                      },
                      child: const Icon(Icons.replay_outlined)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final isLoading = this.user == null;

    if (isLoading) {
      return const Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, $primeiroNome',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(fontSize: 26, color: darkBlueColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                    ),
                    onPressed: () async {
                      _timer.cancel();

                      await Navigator.push(context, MaterialPageRoute(builder: (context) => const IniciarCheckin()));

                      atualizarTela30s();
                    },
                    child: Text(
                      'Iniciar um novo Checkin',
                      style: GoogleFonts.dosis(
                        textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellowColor,
                      ),
                      onPressed: () async {
                        _timer.cancel();
                        atualizarTela30s();
                      },
                      child: const Icon(Icons.replay_outlined)),
                ],
              ),
              SizedBox(
                height: telaHeight * 0.01,
              ),
              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (!isLoading)
                Expanded(
                  child: ListView.builder(
                      itemCount: checkinsSalvos?.length,
                      itemBuilder: (context, index) {
                        final reversedIndex = checkinsSalvos!.length - 1 - index;
                        final checkInId = checkinsSalvos?[reversedIndex].id;
                        final fornecedorDesc = checkinsSalvos?[reversedIndex].fornecedorDesc ?? "Nome não disponível";
                        final status = checkinsSalvos?[reversedIndex].status;
                        final statusDesc = checkinsSalvos?[reversedIndex].statusDesc;
                        final rede = checkinsSalvos?[reversedIndex].grupoEmpresarialDesc;
                        final loja = checkinsSalvos?[reversedIndex].lojaDesc;
                        final dtChegada = checkinsSalvos?[reversedIndex].dtChegada;
                        final dtEntrada = checkinsSalvos?[reversedIndex].dtEntrada;
                        final doca = checkinsSalvos?[reversedIndex].docaDesc ?? 'Doca ainda não disponível';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              fornecedorDesc,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: GestureDetector(
                                onTap: () {
                                  pegarIdNf(checkInId);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              loja.toString(),
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              color: darkBlueColor,
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                        content: SingleChildScrollView(
                                          child: Container(
                                            width: double.maxFinite,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(), // Desativar rolagem do ListView
                                                  itemCount: nfCompraSalvos?.length ?? 0,
                                                  itemBuilder: (context, index) {
                                                    if (nfCompraSalvos != null && index < nfCompraSalvos!.length) {
                                                      final nfCompra = nfCompraSalvos![index];
                                                      final fornecedorDesc = nfCompra.fornecedorDesc ?? "Nome não disponível";
                                                      final numNf = nfCompra.numNf;
                                                      final serieNf = nfCompra.serieNf;
                                                      final status = nfCompra.statusDesc;
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "$fornecedorDesc",
                                                                  style: TextStyle(
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: darkBlueColor,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'NF',
                                                                      style: TextStyle(
                                                                        fontSize: 18.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: darkBlueColor,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '$numNf - $serieNf',
                                                                      style: TextStyle(
                                                                        fontSize: 16.0,
                                                                        color: darkBlueColor,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Status',
                                                                      style: TextStyle(
                                                                        fontSize: 18.0,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: darkBlueColor,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        "$status",
                                                                        style: TextStyle(
                                                                          fontSize: 16.0,
                                                                          color: darkBlueColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          if (index != nfCompraSalvos!.length - 1) SizedBox(height: 10),
                                                          if (index != nfCompraSalvos!.length - 1) Divider(color: Colors.black),
                                                        ],
                                                      );
                                                    } else {
                                                      return SizedBox.shrink();
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Rede',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4.0),
                                                  Text(
                                                    rede.toString(),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  const Text(
                                                    'CheckIn',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4.0),
                                                  Text(
                                                    formatarDataChegada(dtChegada.toString()),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  const Text(
                                                    'Doca',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4.0),
                                                  Text(doca.toString()),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(30.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Loja',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(loja.toString()),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    const Text(
                                                      'Espera',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    Text(
                                                      calcularDiferencaHorasMinutos(dtChegada!, dtEntrada),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Status',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    right: 8.0,
                                                  ),
                                                  child: Icon(
                                                    getStatusIcon(
                                                      getStatusNotaFromString(
                                                        status.toString(),
                                                      ),
                                                    ),
                                                    color: getStatusColor(
                                                      getStatusNotaFromString(
                                                        status.toString(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  statusDesc.toString(),
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: getStatusColor(
                                                      getStatusNotaFromString(
                                                        status.toString(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
            ],
          ),
        ),
      );
    }
  }

  Future<BoolCommitResult> apagarCheckinsAntigos() async {
    var boolCommitResult = await MyDbModel().execSQLList(
      [
        """
          delete from nf_compra
          where id_checkin in (
            select id
            from checkin
            where dtChegada < ${DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch}
          );
        """,
        """
          delete from checkin
          where dtChegada < ${DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch};
        """,
      ]
          .map(
            (e) => e.replaceAll(RegExp(r'^\s+', multiLine: true), " ").replaceAll(RegExp(r'\n'), ""),
          )
          .toList(),
    );
    return boolCommitResult;
  }
}
