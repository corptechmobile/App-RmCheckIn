// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/pages/login/login_page.dart';
import 'package:rmcheckin/app/pages/register/register_codigo/register_codigo_page.dart';
import 'package:rmcheckin/app/pages/register/register_email/register_email.dart';
import 'package:rmcheckin/app/pages/register/register_email/register_email_auth.dart';
import 'package:rmcheckin/app/services/registrar_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';

class Auth extends StatefulWidget {
  final String cpf;
  final String? email;
  final String telefone;
  final String tipoValidacao;
  const Auth({
    Key? key,
    required this.cpf,
    this.email,
    required this.telefone,
    required this.tipoValidacao,
  }) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool primeiroItem = false;
  bool segundoItem = false;
  double opacity = 0.0;
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  void desmarcarPrimeiroCheckbox() {
    setState(() {
      primeiroItem = false;
    });
  }

  String maskEmail(String? email) {
    if (email == null || email.isEmpty) {
      return '';
    }

    int atIndex = email.indexOf('@');
    String username = email.substring(0, 3);
    String domain = email.substring(atIndex);
    String maskedUsername = username + '*' * (email.length - atIndex - 3);
    return maskedUsername + domain;
  }

  String maskPhoneNumber(String phoneNumber) {
    return '${phoneNumber.substring(0, 4)} ****${phoneNumber.substring(phoneNumber.length - 2)}';
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
            SizedBox(
              height: telaHeight * 0.03,
            ),
            Text(
              'Autenticar por:',
              style: GoogleFonts.dosis(
                textStyle: TextStyle(color: darkBlueColor, fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: telaHeight * 0.03,
            ),
            Row(
              children: [
                Checkbox(
                  value: primeiroItem,
                  onChanged: (value) {
                    setState(() {
                      primeiroItem = value!;
                      if (value) {
                        segundoItem = false;
                      }
                    });
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Row(
                        children: [
                          const Icon(Icons.phone),
                          Text(
                            'SMS',
                            style: GoogleFonts.dosis(
                              textStyle: TextStyle(color: darkBlueColor, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        maskPhoneNumber(widget.telefone),
                        style: GoogleFonts.dosis(
                          textStyle: TextStyle(color: darkBlueColor, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: telaHeight * 0.03),
            if (widget.email != null)
              Row(
                children: [
                  Checkbox(
                    value: segundoItem,
                    onChanged: (value) {
                      setState(() {
                        segundoItem = value!;
                        if (segundoItem) {
                          desmarcarPrimeiroCheckbox();
                        }
                      });
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Row(
                          children: [
                            const Icon(Icons.email),
                            Text(
                              'E-mail',
                              style: GoogleFonts.dosis(
                                textStyle: TextStyle(color: darkBlueColor, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          maskEmail(widget.email ?? ''),
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(color: darkBlueColor, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            SizedBox(height: telaHeight * 0.08),
            Center(
              child: AnimatedOpacity(
                opacity: primeiroItem || segundoItem ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    // ignore: unnecessary_null_comparison

                    if (primeiroItem && segundoItem) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, escolha apenas uma opção.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      if (primeiroItem) {
                        apiResponse = await registrarUser(
                          cpf: widget.cpf,
                          email: widget.email,
                          telefone: widget.telefone,
                          tipoValidacao: "sms",
                        );
                        if (apiResponse!['data'] == 'ok') {
                          apiSuccess = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterCodigo(
                                telefone: widget.telefone,
                                cpf: widget.cpf,
                                email: widget.email,
                                tipoValidacao: 'sms',
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            errorMessage = apiResponse!['errors'][0];
                          });
                        }
                      } else if (segundoItem) {
                        apiResponse = await registrarUser(
                          cpf: widget.cpf,
                          email: widget.email,
                          telefone: widget.telefone,
                          tipoValidacao: "email",
                        );
                        if (apiResponse!['data'] == 'ok') {
                          apiSuccess = true;
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterEmailAuth(
                                telefone: widget.telefone,
                                cpf: widget.cpf,
                                email: widget.email,
                                tipoValidacao: 'email',
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            errorMessage = apiResponse!['errors'][0];
                          });
                        }
                      }
                    }
                  },
                  child: const Text('Continuar'),
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

  void updateOpacity() {
    setState(() {
      opacity = (primeiroItem || segundoItem) ? 1.0 : 0.0;
    });
  }
}
