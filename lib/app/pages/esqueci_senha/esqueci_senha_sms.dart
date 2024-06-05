// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import 'package:rmcheckin/app/pages/esqueci_senha/adicionar_nova_senha.dart';
import 'package:rmcheckin/app/services/esqueci_senha_validar_token.dart';
import 'package:rmcheckin/app/widget/app_color.dart';

class EsqueciSenhaSMS extends StatefulWidget {
  final String cpf;
  const EsqueciSenhaSMS({
    Key? key,
    required this.cpf,
  }) : super(key: key);

  @override
  State<EsqueciSenhaSMS> createState() => _EsqueciSenhaSMSState();
}

class _EsqueciSenhaSMSState extends State<EsqueciSenhaSMS> {
  bool isLoading = false;
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

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
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
            const SizedBox(
              height: 10,
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
                // Text(
                //   maskPhoneNumber(widget.telefone),
                //   style: GoogleFonts.dosis(
                //     textStyle: const TextStyle(
                //       color: Colors.grey,
                //       fontSize: 16,
                //     ),
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 40,
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
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Editar numero de telefone?'),
                ),
                OtpTimerButton(
                  backgroundColor: yellowColor,
                  controller: controller,
                  onPressed: () {},
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
            const SizedBox(
              height: 100,
            ),
            Center(
              child: isCodeComplete
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellowColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        try {
                          apiResponse = await EsqueciSenhaDataSorceSMSValidarToken().esqueciSenhaService(cpf: widget.cpf, token: otpController.text);
                          if (apiResponse!['data'] == 'ok') {
                            apiSuccess = true;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarNovaSenha(cpf: widget.cpf)));
                          } else {
                            setState(() {
                              errorMessage = apiResponse!['errors'][0];
                            });
                          }
                        } catch (e) {}
                      },
                      child: const Text('Continuar'),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
