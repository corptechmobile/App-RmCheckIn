import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/pages/home/home_page.dart';
import 'package:rmcheckin/app/pages/login/login_page.dart';
import 'package:rmcheckin/app/services/upload_foto.service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaCadastroFoto extends StatefulWidget {
  const TelaCadastroFoto({super.key});

  @override
  State<TelaCadastroFoto> createState() => _TelaCadastroFotoState();
}

class _TelaCadastroFotoState extends State<TelaCadastroFoto> {
  Motorista? user;
  bool isLoading = false;

  motoristaUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString("data");
    if (jsonDecode(result!).containsKey('data')) {
      user = Motorista.fromMap(jsonDecode(result)['data']);
    } else {
      user = Motorista.fromMap(jsonDecode(result));
    }
    setState(() {});
  }

  Uint8List? imageBytes;
  final ImagePicker _imagePicker = ImagePicker();
  File? imageFile;

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
            final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString('user_photo', base64Encode(imageBytes!));
          }

          setState(() {});
        } else {
          print('Arquivo de imagem não encontrado');
        }
      } else {
        print('Nenhuma imagem selecionada');
      }
      final respostaAPI = await Cadastrarfoto().cadastrarfotoPromotor(cpf: user?.cpf ?? '', file: imageBytes!);
      if (respostaAPI != null) {    
        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => LoginPage())));
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
                'Precisamos tirar uma foto sua!',
                style: GoogleFonts.dosis(
                  textStyle: TextStyle(color: darkBlueColor, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: telaHeight * 0.055,
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
                          "Tirar Foto",
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
