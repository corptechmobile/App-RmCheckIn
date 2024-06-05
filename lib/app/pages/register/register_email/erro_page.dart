// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:rmcheckin/app/pages/register/register_data/register_data.dart';
// import 'package:rmcheckin/app/services/verificar_cpf_service.dart';
// import 'package:rmcheckin/app/widget/app_color.dart';

// class ErrorPageEmail extends StatefulWidget {
//   final String cpf;
//   final String email;
//   final String telefone;
//   const ErrorPageEmail({
//     Key? key,
//     required this.cpf,
//     required this.email,
//     required this.telefone,
//   }) : super(key: key);

//   @override
//   State<ErrorPageEmail> createState() => _ErrorPageEmailState();
// }

// class _ErrorPageEmailState extends State<ErrorPageEmail> {
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     final double buttonWidth = MediaQuery.of(context).size.width * 0.95;
//     final double buttonHeight = MediaQuery.of(context).size.height * 0.07;
//     double telaHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: darkBlueColor,
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         title: Image.asset(
//           'assets/logobranca.png',
//           fit: BoxFit.contain,
//           height: 70,
//           width: 200,
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             SizedBox(
//               height: telaHeight * 0.4,
//               width: 950,
//               child: Image.asset('assets/Captura de tela 2023-09-19 195450.png'),
//             ),
//             SizedBox(
//               height: telaHeight * 0.07,
//             ),
//             Center(
//               child: Text(
//                 'Algo nao deu certo...',
//                 style: GoogleFonts.dosis(
//                   textStyle: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: darkBlueColor,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: telaHeight * 0.02,
//             ),
//             Text(
//               'Acesse sua Caixa de E-mail e clique no \nlink para concluir a verificacao do seu \n E-mail',
//               style: GoogleFonts.dosis(
//                 textStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey,
//                 ),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(
//               height: telaHeight * 0.1,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 10.0, right: 10),
//               child: SizedBox(
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: yellowColor,
//                     minimumSize: const Size(
//                       double.infinity,
//                       50,
//                     ),
//                   ),
//                   onPressed: isLoading
//                       ? null
//                       : () async {
//                           setState(() {
//                             isLoading = true;
//                           });
//                           final success = await VerificarCpfService().login(cpf: widget.cpf);
//                           setState(() {
//                             isLoading = false;
//                           });
//                           if (success) {
//                             // ignore: use_build_context_synchronously
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => RegisterData(
//                                   cpf: widget.cpf,
//                                   email: widget.email,
//                                   telefone: widget.telefone,
//                                 ),
//                               ),
//                             );
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Cpf ainda não foi validado!'),
//                               ),
//                             );
//                           }
//                         },
//                   child: isLoading
//                       ? const CircularProgressIndicator() // Mostrar indicador de carregamento
//                       : Text(
//                           "Continuar",
//                           style: GoogleFonts.dosis(
//                             textStyle: const TextStyle(
//                               fontSize: 17,
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
