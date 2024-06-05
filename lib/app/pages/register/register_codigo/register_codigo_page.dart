// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import 'package:rmcheckin/app/pages/register/register_dados/register_dados.dart';
import 'package:rmcheckin/app/pages/register/register_data/register_data.dart';
import 'package:rmcheckin/app/services/registrar_service.dart';
import 'package:rmcheckin/app/services/verificar_token_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';

class RegisterCodigo extends StatefulWidget {
  final String cpf;
  final String? email;
  final String telefone;
  final String tipoValidacao;

  const RegisterCodigo({
    Key? key,
    required this.cpf,
    this.email,
    required this.telefone,
    required this.tipoValidacao,
  }) : super(key: key);

  @override
  State<RegisterCodigo> createState() => _RegisterCodigoState();
}

class _RegisterCodigoState extends State<RegisterCodigo> {
  bool isLoading = false;
  bool _isButtonEnabled = true;
  bool isCodeComplete = false;
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  OtpTimerButtonController controller = OtpTimerButtonController();
  TextEditingController otpController = TextEditingController();
  String maskPhoneNumber(String phoneNumber) {
    // Adiciona o DDD entre parênteses e mantém os dois últimos dígitos visíveis
    return '${phoneNumber.substring(0, 4)} ****' + phoneNumber.substring(phoneNumber.length - 2);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: yellowColor),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.grey[300],
      ),
    );
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: telaHeight * 0.03,
              ),
              Text(
                "Informe o codigo que \nvocê recebeu por sms",
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(
                    color: darkBlueColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: telaHeight * 0.01,
              ),
              Row(
                children: [
                  Text(
                    'Numero: ',
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    maskPhoneNumber(widget.telefone),
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: telaHeight * 0.05,
              ),
              Pinput(
                length: 6,
                controller: otpController,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onChanged: (code) {
                  setState(() {
                    isCodeComplete = code.length == 6;
                  });
                },
                // onCompleted: (pin) => print(pin),
              ),
              SizedBox(
                height: telaHeight * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyPhone()));
                    },
                    child: const Text('Editar numero de telefone?'),
                  ),
                  OtpTimerButton(
                    backgroundColor: yellowColor,
                    controller: controller,
                    onPressed: () {
                      controller.startTimer();
                      registrarUser(
                        cpf: widget.cpf,
                        email: widget.email,
                        telefone: widget.telefone,
                        tipoValidacao: "sms",
                      );
                    },
                    duration: 300,
                    text: Text(
                      'Reenviar sms',
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: telaHeight * 0.09,
              ),
              Center(
                child: isCodeComplete
                    ? ElevatedButton(
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
                                  try {
                                    apiResponse = await VerificarTokenService().verificarToken(widget.telefone, otpController.text);
                                    if (apiResponse!['data'] == 'ok') {
                                      apiSuccess = true;
                                      Navigator.push(
                                          // ignore: use_build_context_synchronously
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RegisterData(
                                                    cpf: widget.cpf,
                                                    email: widget.email,
                                                    telefone: widget.telefone,
                                                  )));
                                    } else {
                                      setState(() {
                                        errorMessage = apiResponse!['errors'][0];
                                      });
                                    }
                                  } catch (e) {
                                    errorMessage = 'Erro ao se comunicar com o servidor';
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
                      )
                    : Container(),
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
      ),
    );
  }
}
