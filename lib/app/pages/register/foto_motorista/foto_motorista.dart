// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rmcheckin/app/pages/register/sucesso_cadastro/sucesso_cadastro.dart';
import 'package:rmcheckin/app/services/upload_foto.service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';

class FotoMotorista extends StatefulWidget {
  final String cpf;
  final String? email;
  final String telefone;
  final String nome;
  final String password;
  const FotoMotorista({
    Key? key,
    required this.cpf,
    this.email,
    required this.telefone,
    required this.nome,
    required this.password,
  }) : super(key: key);

  @override
  State<FotoMotorista> createState() => _FotoMotoristaState();
}

class _FotoMotoristaState extends State<FotoMotorista> {
  Uint8List? imageBytes;
  final ImagePicker _imagePicker = ImagePicker();
  File? imageFile;
  bool isLoading = false;
  pick(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        imageFile = File(image.path);

        if (imageFile!.existsSync()) {
          final compressedImageBytes = await FlutterImageCompress.compressWithFile(
            imageFile!.path,
            quality: 85,
          );

          if (compressedImageBytes != null) {
            imageBytes = Uint8List.fromList(compressedImageBytes);
          }

          setState(() {});
        } else {
          print('Arquivo de imagem não encontrado');
        }
      } else {
        print('Nenhuma imagem selecionada');
      }
      final respostaAPI = await Cadastrarfoto().cadastrarfotoPromotor(cpf: widget.cpf, file: imageBytes!);
      if (respostaAPI != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SucessoPageCadastro(
              cpf: widget.cpf,
              password: widget.password,
              nome: widget.nome,
              telefone: widget.telefone,
              email: widget.email,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Erro ao enviar a foto. Tente novamente.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('Erro ao selecionar a imagem: $e');
    }
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
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: telaHeight * 0.1,
            ),
            Center(
              child: Text(
                'Estamos quase lá!',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(color: darkBlueColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: telaHeight * 0.055,
            ),
            Text(
              'Agora, precisamos de uma foto sua \n tudo bem?',
              style: GoogleFonts.dosis(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: telaHeight * 0.055,
            ),
            Text(
              'Tire uma selfie com a camera \nposicionada a frente de seu rosto e \nombros',
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
              height: telaHeight * 0.097,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: SizedBox(
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          await pick(ImageSource.camera);
                          setState(() {
                            isLoading = false;
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellowColor,
                    minimumSize: const Size(
                      double.infinity,
                      50,
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
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
          ],
        ),
      ),
    );
  }
}
