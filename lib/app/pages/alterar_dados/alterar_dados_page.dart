import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rmcheckin/app/models/motorista_auth_model.dart';
import 'package:rmcheckin/app/pages/alterar_dados/alterar_dados_sucesso.dart';
import 'package:rmcheckin/app/services/redefine_dados_service.dart';
import 'package:rmcheckin/app/services/upload_foto.service.dart';
import 'package:rmcheckin/app/widget/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AlterarDadosPage extends StatefulWidget {
  const AlterarDadosPage({
    super.key,
    required this.update,
  });
  final Function update;
  @override
  // ignore: no_logic_in_create_state
  State<AlterarDadosPage> createState() => _AlterarDadosPageState(update);
}

class _AlterarDadosPageState extends State<AlterarDadosPage> {
  final Function update;

  _AlterarDadosPageState(this.update);
  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var maskFormatterData = MaskTextInputFormatter(
    mask: '##/##/####',
    type: MaskAutoCompletionType.lazy,
  );
  Uint8List? imageBytes;
  Motorista? user;
  bool isLoading = false;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _telefoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    motoristaUser();
  }

  motoristaUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = sharedPreferences.getString("data");
    if (jsonDecode(result!).containsKey('data')) {
      user = Motorista.fromMap(jsonDecode(result)['data']);
    } else {
      user = Motorista.fromMap(jsonDecode(result));
    }
    setState(() {
      _nomeController.text = user!.nome;
      _emailController.text = user!.email;
      _telefoneController.text = user!.telefone;
    });
  }
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
          }

          setState(() {});
        }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 200));
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/checkin');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alterar dados cadastrais",
                  style: GoogleFonts.dosis(
                    textStyle: TextStyle(fontSize: 24, color: darkBlueColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                   child:   Center(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Stack(
                          children: [
                            SizedBox(
                                width: 170,
                                height: telaHeight * 0.25,
                                child: imageBytes == null
                                    ? CachedNetworkImage(
                                        imageUrl: user!.foto,
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: imageProvider,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 170,
                                        height: telaHeight * 0.25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(imageBytes!),
                                            ),
                                          ),
                                        ),
                                      )),
                            Positioned(
                              bottom: 10,
                              left: 130,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellow[600], // Cor de fundo amarela
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    _showOpcoesBottomSheet();
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 2.0,
                  ),
                  child: Text(
                    'Nome',
                    style: GoogleFonts.dosis(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _nomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite um nome válido';
                    }
                    return null;
                  },
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    // hintText: "Digite aqui o seu nome completo",
                    // labelText: "Nome",
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
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                        ),
                        child: Text(
                          'Email',
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,                      
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
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
                SizedBox(
                  height: telaHeight * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                        ),
                        child: Text(
                          'Numero de telefone',
                          style: GoogleFonts.dosis(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _telefoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Digite um número de telefone válido';
                          }

                          return null;
                        },
                        inputFormatters: [maskFormatter],
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          // hintText: "(00) 0000-0000",
                          // labelText: "Telefone",
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
                SizedBox(
                  height: telaHeight * 0.05,
                ),
                ElevatedButton(
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
                            setState(() {
                              isLoading = true;
                            });
                              String? foto;
                              if (imageBytes != null) {
                                foto = await Cadastrarfoto().cadastrarfotoPromotor(cpf: user!.cpf, file: imageBytes!);
                              }
                            bool success = await redefineUser(
                               foto: foto ?? user!.foto,
                              nome: _nomeController.text,
                              email: _emailController.text,
                              cpf: user!.cpf,
                              telefone: _telefoneController.text,
                            );
                            setState(() {
                              isLoading = false;
                            });
                            if (success) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AlterarDadosSucesso(),
                                ),
                              );
                            } else {                            
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Erro ao atualizar os dados do usuário.'),
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          "Salvar",
                          style: GoogleFonts.dosis(
                            textStyle: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
 void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera(),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();

                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      PhosphorIcons.camera(),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
