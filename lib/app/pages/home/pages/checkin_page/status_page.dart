// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:rmcheckin/app/const/const.dart';
// import 'package:rmcheckin/app/models/motorista_auth_model.dart';
// import 'package:rmcheckin/app/models/nf_compra.dart';
// import 'package:rmcheckin/app/shared/theme/enum_color_status.dart';
// import 'package:rmcheckin/app/widget/app_color.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StatusPage extends StatefulWidget {
//   final int checkInId;

//   const StatusPage({
//     Key? key,
//     required this.checkInId,
//   }) : super(key: key);

//   @override
//   State<StatusPage> createState() => _StatusPageState();
// }

// class _StatusPageState extends State<StatusPage> {
//   Motorista? user;
//   List<NFCompra> notas = [];
//   bool loading = true;
//   Map<String, dynamic>? dataInfo;
//   motoristaUser() async {
//     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     final result = sharedPreferences.getString("data");
//     setState(() {
//       user = Motorista.fromMap(jsonDecode(result!)["data"]);
//       dataInfo = jsonDecode(sharedPreferences.getString('dataInfo') ?? '{}');
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback(
//       (timeStamp) async {
//         await motoristaUser();
//         await _carregarStatusNotasFiscais();
//         _startTimer();
//       },
//     );
//   }

//   Future<void> _carregarStatusNotasFiscais() async {
//     try {
//       List<NFCompra> notasDaAPI = await getStatusNotasFiscais(user!.cpf, widget.checkInId);

//       setState(() {
//         notas = notasDaAPI;
//         loading = false;
//       });
//     } catch (error) {
//       print('Erro ao carregar status das notas fiscais: $error');
//       // Trate o erro conforme necessário
//     }
//   }

//   bool loadingTimer = false;
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
//       try {
//         setState(() {
//           loadingTimer = true;
//         });

//         await _carregarStatusNotasFiscais();
//       } finally {
//         setState(() {
//           loadingTimer = false;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel(); // Cancel the timer
//     // Dispose of other controllers and listeners
//     super.dispose();
//   }

//   bool timerLoading = false;
//   Timer? _timer;
//   @override
//   Widget build(BuildContext context) {
//     String nomeCompleto = user!.nome;
//     List<String> partesDoNome = nomeCompleto.split(' ');
//     String primeiroNome = partesDoNome.isNotEmpty ? partesDoNome[0] : '';
//     if (loadingTimer || loading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         backgroundColor: darkBlueColor,
//         title: Image.asset(
//           'assets/Captura de tela 2023-09-19 181800.png',
//           fit: BoxFit.contain,
//           height: 62,
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '$primeiroNome, Acompanhe o status das suas NFs:',
//               style: TextStyle(fontSize: 18, color: darkBlueColor, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: notas.length,
//                 itemBuilder: (context, index) {
//                   if (index == 0 || notas[index].fornecedorDesc != notas[index - 1].fornecedorDesc) {
//                     // Se for o primeiro item ou o fornecedor mudou, exibe o nome do fornecedor
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
//                           child: Text(
//                             '${notas[index].fornecedorDesc}',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16.0,
//                             ),
//                           ),
//                         ),
//                         _buildNotaFiscalCard(notas[index], dataInfo),
//                       ],
//                     );
//                   } else {
//                     return _buildNotaFiscalCard(notas[index], dataInfo);
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<List<NFCompra>> getStatusNotasFiscais(String cpf, int checkInId) async {
//     var url = Uri.parse(ConstsApi.statusService);
//     var response = await http.post(
//       url,
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'authorization': ConstsApi.basicAuth,
//         'Accept-Charset': 'utf-8',
//       },
//       body: jsonEncode(
//         <String, dynamic>{'cpf': cpf, 'checkInId': checkInId},
//       ),
//     );

//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(utf8.decode(response.bodyBytes));
//       if (responseData['data'] != null && responseData['data']['notas'] != null) {
//         List<dynamic> notasJson = responseData['data']['notas'];

//         List<NFCompra> notas = notasJson.map((notaJson) {
//           return NFCompra(
//             id: notaJson['id'],
//             chaveNf: notaJson['chaveNf'],
//             fornecedorDesc: notaJson['fornecedorDesc'],
//             valorTotal: notaJson['valorTotal'],
//             statusDesc: notaJson['statusDesc'],
//             checkInId: notaJson['checkInId'],
//             numNf: notaJson['numNf'],
//             serieNf: notaJson['serieNf'],
//             dtCadastro: notaJson['dtCadastro'],
//             status: notaJson['status'],
//             dtEntrada: notaJson['dtEntrada'],
//             erpId: notaJson['erpId'],
//           );
//         }).toList();

//         return notas;
//       } else {
//         throw Exception('Resposta da API inválida: ${response.body}');
//       }
//     } else {
//       throw Exception('Erro ao obter status das notas fiscais: ${response.statusCode}');
//     }
//   }
// }

// Widget _buildNotaFiscalCard(NFCompra nota, Map<String, dynamic>? dataInfo) {
//   StatusNota notaStatus = getStatusNotaFromString(nota.status);
//   Color statusColor = getStatusColor(notaStatus);
//   return Card(
//     elevation: 5.0,
//     margin: const EdgeInsets.symmetric(vertical: 8.0),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(15.0),
//     ),
//     child: ListTile(
//       contentPadding: const EdgeInsets.all(16.0),
//       title: Text(
//         'NF: ${nota.numNf}-${nota.serieNf}',
//         style: const TextStyle(
//           fontSize: 18.0,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 8.0),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(8.0),
//             color: statusColor,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Status da nota: ${nota.statusDesc}',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   'Status de entrada: ${nota.status}',
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           if (dataInfo != null) ...[
//             Row(
//               children: [
//                 Text(
//                   'Data de chegada:',
//                   style: TextStyle(
//                     fontSize: 14.0,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 4,
//                 ),
//                 Text(
//                   DateFormat('dd/MM/yyyy').format(DateTime.parse(dataInfo["dtChegada"])),
//                   style: const TextStyle(
//                     fontSize: 14.0,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 4,
//                 ),
//                 const Text('as'),
//                 SizedBox(
//                   width: 4,
//                 ),
//                 Text(
//                   DateFormat('HH:mm').format(DateTime.parse(dataInfo["dtChegada"])),
//                   style: const TextStyle(
//                     fontSize: 14.0,
//                   ),
//                 )
//               ],
//             ),
//           ],
//           const SizedBox(height: 8.0),
//           Row(
//             children: [
//               const Text('Data de cadastro da nota:'),
//               SizedBox(
//                 width: 4,
//               ),
//               Text(
//                 DateFormat('dd/MM/yyyy').format(DateTime.parse(nota.dtCadastro)),
//                 style: const TextStyle(
//                   fontSize: 14.0,
//                 ),
//               ),
//               SizedBox(
//                 width: 4,
//               ),
//               Text('as'),
//               SizedBox(
//                 width: 4,
//               ),
//               Text(
//                 DateFormat('HH:mm').format(DateTime.parse(nota.dtCadastro)),
//               ),
//             ],
//           ),
//           SizedBox(height: 8.0),
//           SizedBox(height: 8.0),
//           if (dataInfo != null) ...[
//             Text(
//               'Loja: ${dataInfo["lojaDesc"] ?? "N/A"}',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               'Rede: ${dataInfo["grupoEmpresarialDesc"] ?? "N/A"}',
//               style: TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//           ],
//         ],
//       ),
//     ),
//   );
// }
