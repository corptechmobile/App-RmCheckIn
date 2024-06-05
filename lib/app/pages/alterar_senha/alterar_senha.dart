import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/pages/alterar_senha/sucesso.dart';
import 'package:rmcheckin/app/services/alterar_senha_service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlterarSenha extends StatefulWidget {
  const AlterarSenha({super.key});

  @override
  State<AlterarSenha> createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  TextEditingController confirmarSenha = TextEditingController();
  TextEditingController senhaAtual = TextEditingController();
  TextEditingController novaSenha = TextEditingController();
  Motorista? user;
  motoristaUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString("data");
    setState(() {
      user = Motorista.fromMap(jsonDecode(result!)["data"]);
    });
  }

  bool isLoading = false;
  String errorMessage = '';
  String? _validatePasswordMatch(String value) {
    if (value != novaSenha.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  bool validarSenha(String senha) {
    if (senha.length < 6) {
      return false;
    }

    if (!senha.contains(RegExp(r'\d'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[a-z]'))) {
      return false;
    }

    if (!senha.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    if (senha.contains(RegExp(r'\s'))) {
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    motoristaUser();
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vamos alterar sua senha',
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(fontSize: 26, color: darkBlueColor, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    'Senha atual',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                TextFormField(
                  controller: senhaAtual,
                   validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha.';
                    }
                    
                
                  },
                  obscureText: _showPassword == false ? true : false,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onTap: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    hintText: 'Senha atual',
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
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text(
                            'Nova Senha',
                            style: GoogleFonts.dosis(
                              textStyle: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold),
                            ),
                          )),
                      TextFormField(
                        controller: novaSenha,
                       validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha.';
                    }
                    return null;
                
                  },
                        obscureText: _showPassword == false ? true : false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                            onTap: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                          hintText: 'Nova senha',
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: confirmarSenha,
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma senha.';
                    }
                     if (_validatePasswordMatch(value) != null) {
                        return 'Senhas diferentes';
                      }
                return null;
                  },
                    obscureText: _showPassword == false ? true : false,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        child: Icon(_showPassword == false ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onTap: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      hintText: 'Nova Senha',
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
                  height: telaHeight * 0.060,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
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
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  isLoading = true;
                                });

                                bool apiSuccess = await AlterarSenhaDataSorce()
                                    .alterarSenhaService(passwordNew: novaSenha.text, passwordOld: senhaAtual.text, cpf: user!.cpf);
                                if (!apiSuccess) {
                                  setState(() {
                                    errorMessage = 'Senha antiga inválida';
                                  });
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                if (apiSuccess) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SucessoPage(),
                                    ),
                                  );
                                }
                              }
                              novaSenha.clear();
                              confirmarSenha.clear();
                              senhaAtual.clear();
                            },
                      child: isLoading
                          ? const CircularProgressIndicator() // Mostrar indicador de carregamento
                          : Text(
                              'Confirmar',
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
