import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/pages/esqueci_senha/sucesso_email.dart';
import 'package:rmcheckin/app/services/esqueci_senha.dart';
import 'package:rmcheckin/app/widget/app_color.dart';

class EsqueciSenhaEmail extends StatefulWidget {
  const EsqueciSenhaEmail({super.key});

  @override
  State<EsqueciSenhaEmail> createState() => _EsqueciSenhaEmailState();
}

class _EsqueciSenhaEmailState extends State<EsqueciSenhaEmail> {
  bool _isButtonEnabled = true;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                ),
                child: Text(
                  'Digite seu endereco de e-mail para redefinir sua \nsenha. Enviaremos um e-mail com o passo a passo, portanto, não esqueça de conferir\ntambém a sua caixa de spam.',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: telaHeight * 0.020,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, insira um endereço de e-mail.';
                          }
                          if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(value)) {
                            return 'Por favor, insira um endereço de e-mail válido.';
                          }
                          return null;
                        },
                        cursorColor: Colors.grey,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "E-mail",
                          hintStyle: GoogleFonts.dosis(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12.0,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[300],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: telaHeight * 0.080,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0, right: 1, top: 0),
                      child: SizedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: yellowColor,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: _isButtonEnabled
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isButtonEnabled = false;
                                    });
                                    apiResponse = await EsqueciSenhaDataSorce().esqueciSenhaService(email: _emailController.text);

                                    if (apiResponse!['data'] == 'ok') {
                                      // ignore: use_build_context_synchronously
                                      apiSuccess = true;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const EsqueciSenhaSucesso(),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        errorMessage = apiResponse!['errors'][0];
                                      });
                                    }

                                    setState(() {
                                      _isButtonEnabled = true;
                                    });
                                  }
                                }
                              : null,
                          child: _isButtonEnabled
                              ? Text(
                                  "Redefinir minha senha",
                                  style: GoogleFonts.dosis(
                                    textStyle: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : const CircularProgressIndicator(),
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
            ],
          ),
        ));
  }
}
