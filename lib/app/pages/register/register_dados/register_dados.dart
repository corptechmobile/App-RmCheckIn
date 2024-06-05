import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rmcheckin/app/pages/register/register_codigo/register_codigo_page.dart';
import 'package:rmcheckin/app/pages/register/register_auth/auth.dart';
import 'package:rmcheckin/app/services/registrar_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:validadores/validadores.dart';

class MyPhone extends StatefulWidget {
    final String? cpfFromLogin;
  const MyPhone({Key? key, this.cpfFromLogin}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  bool apiSuccess = false;
  Map<String, dynamic>? apiResponse;
  String? errorMessage;
  bool isCPFValid(String cpf) {
    if (cpf == null || cpf.isEmpty) {
      return false;
    }
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11) {
      return false;
    }
    if (cpf.runes.toSet().length == 1) {
      return false;
    }
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int primeiroDigito = (soma * 10) % 11;

    if (primeiroDigito != int.parse(cpf[9])) {
      return false;
    }
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    int segundoDigito = (soma * 10) % 11;
    return segundoDigito == int.parse(cpf[10]);
  }

  TextEditingController telefoneController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var maskformaterCpf = MaskTextInputFormatter(
    mask: '###.###.###.##',
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    
    cpfController.text = widget.cpfFromLogin ?? '';
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 200));
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: telaHeight * 0.03,
                ),
                Text(
                  "Antes de tudo,\nvamos criar\nsua conta.",
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(color: darkBlueColor, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.04,
                ),
                Text(
                  "Informe seu numero de CPF",
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: darkBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  controller: cpfController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [maskformaterCpf],
                  cursorColor: Colors.black,
                  validator: (value) {
                    return Validador()
                        .add(Validar.CPF, msg: 'CPF Inválido')
                        .add(Validar.OBRIGATORIO, msg: 'Campo obrigatório')
                        .minLength(11)
                        .maxLength(11)
                        .valido(value, clearNoNumber: true);
                  },
                  decoration: InputDecoration(
                    hintText: "000.000.000-00",
                    prefixIcon: const Icon(
                      Icons.login,
                      color: Colors.grey,
                    ),
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
                SizedBox(
                  height: telaHeight * 0.02,
                ),
              
                
                Text(
                  "Informe seu numero de telefone",
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: darkBlueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextFormField(
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [maskFormatter],
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite um numero de telefone válido';
                    }

                    if (value.replaceAll(RegExp(r'[^\d]'), '').length < 10) {
                      return 'Número de telefone inválido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "(00) 00000-0000",
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
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
                SizedBox(
                  height: telaHeight * 0.09,
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellowColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        String? email = emailController.text.isNotEmpty ? emailController.text : null;
                          apiResponse = await registrarUser(
                          cpf: cpfController.text,
                          email: email,
                          telefone: telefoneController.text,
                          tipoValidacao: "sms",
                        );
                         if (apiResponse!['data'] == 'ok') {
                          apiSuccess = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterCodigo(
                                telefone: telefoneController.text,
                                cpf: cpfController.text,
                                email: email,
                                tipoValidacao: 'sms',
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            errorMessage = apiResponse!['errors'][0];
                          });
                        }
                      }
                    },
                    child: Text(
                      'Continuar',
                      style: GoogleFonts.dosis(
                        textStyle: const TextStyle(
                          fontSize: 17,
                          color: Colors.black,
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
        ),
      ),
    );
  }
}

const snackBar = SnackBar(
  content: Text(
    'Algo deu errado, revise seus dados cadastrais',
    textAlign: TextAlign.center,
  ),
  backgroundColor: Colors.red,
);
