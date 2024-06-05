// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rmcheckin/app/models/motorista_auth_model.dart';
// import 'package:rmcheckin/app/pages/caminhao/teste.dart';
// import 'package:rmcheckin/app/services/registrar_veiculo_service.dart';
// import 'package:rmcheckin/app/services/tipo_veiculo_service.dart';
// import 'package:rmcheckin/app/widget/app_color.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CaminhaoPage extends StatefulWidget {
//   const CaminhaoPage({Key? key}) : super(key: key);

//   @override
//   State<CaminhaoPage> createState() => _CaminhaoPageState();
// }

// class _CaminhaoPageState extends State<CaminhaoPage> {
//   Motorista? user;
//   final TextEditingController placaController = TextEditingController();
//   late Future<List<String>> tiposCaminhao;

//   @override
//   void initState() {
//     super.initState();
//     motoristaUser();
//     tiposCaminhao = _fetchTiposCaminhao();
//   }

//   Future<void> motoristaUser() async {
//     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     final result = sharedPreferences.getString("data");
//     setState(() {
//       user = Motorista.fromMap(jsonDecode(result!)["data"]);
//     });
//   }

//   Future<List<String>> _fetchTiposCaminhao() async {
//     try {
//       final tipos = await TipoVeiculoService().tipoVeiculo();
//       return tipos as List<String>;
//     } catch (e) {
//       // Trate erros, se necessário
//       print('Erro ao buscar tipos de veículos: $e');
//       return [];
//     }
//   }

//   Future<void> _showExitConfirmationDialog(BuildContext context) async {
//     final List<String> tipos = await tiposCaminhao;

//     showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Adicione um novo veículo',
//             style: GoogleFonts.dosis(
//               textStyle: TextStyle(
//                 fontSize: 26,
//                 color: darkBlueColor,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           content: Column(
//             children: [
//               DropdownButton<String>(
//                 isExpanded: true,
//                 hint: const Text("Selecione o tipo veículo"),
//                 value: tipos.isNotEmpty ? tipos.first : null,
//                 onChanged: (escolha) {
//                   // Lógica de atualização da escolha
//                 },
//                 items: tipos
//                     .map((tipo) => DropdownMenuItem(
//                           value: tipo,
//                           child: Text(tipo),
//                         ))
//                     .toList(),
//               ),
//               TextFormField(
//                 controller: placaController,
//                 // Restante do seu código para o TextFormField
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text(
//                 'Concluir',
//                 style: GoogleFonts.dosis(
//                   textStyle: TextStyle(
//                     fontSize: 17,
//                     color: darkBlueColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               onPressed: () {},
//             ),
//             TextButton(
//               child: Text(
//                 'Cancelar',
//                 style: GoogleFonts.dosis(
//                   textStyle: TextStyle(
//                     fontSize: 17,
//                     color: darkBlueColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Fecha o diálogo
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           // AppBar
//           ),
//       body: user != null ? VeiculoRedeCard(motorista: user!) : const CircularProgressIndicator(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           _showExitConfirmationDialog(context);
//         },
//         // Restante do seu código para o FloatingActionButton
//       ),
//     );
//   }
// }
