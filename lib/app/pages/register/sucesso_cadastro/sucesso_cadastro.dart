// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/pages/login/login_page.dart';
import 'package:rmcheckin/app/services/finalizar_registro_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';

class SucessoPageCadastro extends StatefulWidget {
  final String cpf;
  final String? email;
  final String telefone;
  final String nome;
  final String password;
  final Uint8List? foto;
  const SucessoPageCadastro({
    Key? key,
    required this.cpf,
    this.email,
    required this.telefone,
    required this.nome,
    required this.password,
    this.foto,
  }) : super(key: key);

  @override
  State<SucessoPageCadastro> createState() => _SucessoPageCadastroState();
}

class _SucessoPageCadastroState extends State<SucessoPageCadastro> {
  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.95;
    final double buttonHeight = MediaQuery.of(context).size.height * 0.07;
    double screenHeight = MediaQuery.of(context).size.height;
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
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   height: screenHeight * 0.4,
              //   width: 350,
              //   child: Image.network('http://acesso.novoatacarejo.com/resources/rede/img/novoImgCadSucesso.jpg'),
              // ),
              // SizedBox(
              //   height: screenHeight * 0.08,
              // ),
              // Text(
              //   'Maravilha',
              //   textAlign: TextAlign.center,
              //   style: GoogleFonts.dosis(
              //     textStyle: TextStyle(
              //       fontSize: 24,
              //       fontWeight: FontWeight.bold,
              //       color: darkBlueColor,
              //     ),
              //   ),
              // ),
              if (widget.foto != null) // Verificando se a foto não é nula
                Image.memory(
                  widget.foto!, // Mostrando a foto do usuário
                  width: 150, // Defina a largura e a altura de acordo com suas necessidades
                  height: 150,
                ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Cadastro realizado com sucesso!',
                style: GoogleFonts.dosis(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight * 0.2,
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellowColor,
                          minimumSize: const Size(
                            double.infinity,
                            50,
                          ),
                        ),
                        onPressed: () {
                          finalizarRegistro(
                            nome: widget.nome,
                            cpf: widget.cpf,
                            email: widget.email,
                            password: widget.password,
                            telefone: widget.telefone,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Ir para o login',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
