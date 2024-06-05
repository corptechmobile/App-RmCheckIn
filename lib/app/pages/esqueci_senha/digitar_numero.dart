import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rmcheckin/app/pages/esqueci_senha/esqueci_senha_sms.dart';
import 'package:rmcheckin/app/services/esqueci_senha_sms.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:validadores/Validador.dart';

class DigitarNumero extends StatefulWidget {
  const DigitarNumero({super.key});

  @override
  State<DigitarNumero> createState() => _DigitarNumeroState();
}

class _DigitarNumeroState extends State<DigitarNumero> {
  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
   var maskformaterCpf = MaskTextInputFormatter(
    mask: '###.###.###.##',
    type: MaskAutoCompletionType.lazy,
  );
  bool _isButtonEnabled = true;
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  TextEditingController digitarNumero = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              'Digite seu numero de CPF',
              style: GoogleFonts.dosis(
                textStyle: TextStyle(
                  color: darkBlueColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                   child: TextFormField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'CPF',
                      hintStyle: GoogleFonts.dosis(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12.0,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                      prefixIcon: const Icon(
                        Icons.login,
                        color: Colors.grey,
                      ),
                    ),
                    inputFormatters: [maskformaterCpf],
                    controller: digitarNumero,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return Validador()
                          .add(Validar.CPF, msg: 'CPF Inválido')
                          .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                          .minLength(11)
                          .maxLength(11)
                          .valido(value, clearNoNumber: true);
                    },
                  ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
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
                          apiResponse = await EsqueciSenhaDataSorceSMS().esqueciSenhaService(cpf: digitarNumero.text);

                          if (apiResponse!['data'] == 'ok') {
                            apiSuccess = true;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EsqueciSenhaSMS(
                                  cpf: digitarNumero.text,
                                ),
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
                        "Continuar",
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
