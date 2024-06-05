import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rmcheckin/app/pages/esqueci_senha/digitar_numero.dart';
import 'package:rmcheckin/app/pages/esqueci_senha/esqueci_senha_email.dart';
import 'package:rmcheckin/app/pages/esqueci_senha/esqueci_senha_sms.dart';
import 'package:rmcheckin/app/widget/app_color.dart';

class EsqueciSenha extends StatefulWidget {
  EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
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
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Esqueceu?\nTudo bem.',
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
              height: telaHeight * 0.04,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: yellowColor,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DigitarNumero()));
              },
              child: const Text('Redefinir senha por SMS'),
            ),
            const SizedBox(
              height: 20,
            ),
  
          ],
        ),
      ),
    );
  }
}
