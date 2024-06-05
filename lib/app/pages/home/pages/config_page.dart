// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/models/model.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';

import 'package:rmcheckin/app/pages/alterar_senha/alterar_senha.dart';
import 'package:rmcheckin/app/pages/input/input_screen.dart';
import 'package:rmcheckin/app/services/inativar_conta_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Impede o fechamento do diálogo ao tocar fora dele
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sair do aplicativo?',
            style: GoogleFonts.dosis(
                textStyle: TextStyle(
              fontSize: 26,
              color: darkBlueColor,
              fontWeight: FontWeight.bold,
            )),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Tem certeza de que deseja sair do aplicativo?',
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
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
                )),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text(
                'Sair',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 17,
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () async {
                bool saiu = await sair();

                if (saiu) {
                  Navigator.of(context).pop();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InputScreen(),
                    ),
                  );
                }
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }

  Motorista? user;
  motoristaUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = await sharedPreferences.getString("data");
    setState(() {
      user = Motorista.fromMap(jsonDecode(result!));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        motoristaUser();
      },
    );
  }

  Future<void> _showDeleteAccountConfirmationDialog(BuildContext context) async {
    bool confirmDelete = false;
    bool isDeleteAccountChecked = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Excluir Minha Conta',
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
                    'Todos os seus dados serão apagados, deseja continuar?',
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
                        'Estou ciente dessa ação',
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
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
                      bool deleted = await DeixarUserInativo().deixarUserInativo(cpf: user!.cpf);
                      if (deleted) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputScreen(),
                          ),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao excluir conta. Tente novamente.'),
                          ),
                        );
                      }
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 200));
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/checkin');
          },
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellowColor,
        onPressed: () async {
          _showExitConfirmationDialog(context);
        },
        child: const Icon(
          Icons.logout,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              "Notificações",
              style: GoogleFonts.dosis(
                textStyle: TextStyle(
                  color: darkBlueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Perfimitir notificações na tela bloqueada',
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Checkbox(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
                'Acesso',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: yellowColor, minimumSize: const Size(double.infinity, 50)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AlterarSenha()));
                        },
                        child: Text(
                          'Alterar senha',
                          style: GoogleFonts.dosis(
                            textStyle: const TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: yellowColor, minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        _showDeleteAccountConfirmationDialog(context);
                      },
                      child: Text(
                        'Excluir conta',
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(color: Colors.black, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> sair() async {
    MyDbModel().writeDatabase(ByteData(0));

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();

    return true;
  }
}
