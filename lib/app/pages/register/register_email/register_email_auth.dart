// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/pages/register/register_data/register_data.dart';
import 'package:rmcheckin/app/services/verificar_cpf_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';

class RegisterEmailAuth extends StatefulWidget {
  final String cpf;
  final String? email;
  final String telefone;
  final String tipoValidacao;
  RegisterEmailAuth({
    Key? key,
    required this.cpf,
    this.email,
    required this.telefone,
    required this.tipoValidacao,
  }) : super(key: key);

  @override
  State<RegisterEmailAuth> createState() => _RegisterEmailAuthState();
}

class _RegisterEmailAuthState extends State<RegisterEmailAuth> {
  bool isLoading = false;

  _RegisterEmailAuthState();
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
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
        child: Column(
          children: [
            const SizedBox(height: 15),
            SizedBox(
              height: telaHeight * 0.32,
            ),
            Center(
              child: Text(
                'Conta criada!',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkBlueColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: telaHeight * 0.02,
            ),
            Text(
              'Verifique seu e-mail para valida-lo \mantes de continuar',
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
              height: telaHeight * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
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
                          setState(() {
                            isLoading = true;
                          });
                          apiResponse = await VerificarCpfService().login(cpf: widget.cpf);
                          setState(() {
                            isLoading = false;
                          });
                          if (apiResponse!['data'] == 'ok') {
                            apiSuccess = true;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterData(
                                  cpf: widget.cpf,
                                  email: widget.email,
                                  telefone: widget.telefone,
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              errorMessage = apiResponse!['errors'][0];
                            });
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator() // Mostrar indicador de carregamento
                      : Text(
                          "Continuar",
                          style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            errorMessage != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
