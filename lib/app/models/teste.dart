// import 'dart:convert';

// import 'package:rmcheckin/app/models/checkin_teste.dart';

// class Checkin {
//   final int id;
//   final int grupoEmpresarialId;
//   final String grupoEmpresarialDesc;
//   final int lojaId;
//   final String lojaDesc;
//   final int fornecedorId;
//   final String fornecedorDesc;
//   // ... outras propriedades

//   final List<NotaFiscal> notas; // Adicione esta linha

//   Checkin({
//     required this.id,
//     required this.grupoEmpresarialId,
//     required this.grupoEmpresarialDesc,
//     required this.lojaId,
//     required this.lojaDesc,
//     required this.fornecedorId,
//     required this.fornecedorDesc,
//     required this.notas, // Adicione esta linha
//   });

//   factory Checkin.fromJson(Map<String, dynamic> json) {
//     List<dynamic> notasJson = json['data']['notas'];
//     List<NotaFiscal> notasFiscais = notasJson.map((notaJson) {
//       return NotaFiscal(
//         id: notaJson['id'],
//         checkInId: notaJson['checkInId'],
//         fornecedorDesc: notaJson['fornecedorDesc'],
//         chaveNf: notaJson['chaveNf'],
//         numNf: notaJson['numNf'],
//         serieNf: notaJson['serieNf'],
//         statusDesc: notaJson['statusDesc'],
//         dtCadastro: notaJson['dtCadastro'],
//         valorTotal: notaJson['valorTotal'],
//         lojaDesc: notaJson['lojaDesc'],
//       );
//     }).toList();

//     return Checkin(
//       id: json['data']['id'],
//       grupoEmpresarialId: json['data']['grupoEmpresarialId'],
//       grupoEmpresarialDesc: json['data']['grupoEmpresarialDesc'],
//       lojaId: json['data']['lojaId'],
//       lojaDesc: json['data']['lojaDesc'],
//       fornecedorId: json['data']['fornecedorId'],
//       fornecedorDesc: json['data']['fornecedorDesc'],
//       notas: notasFiscais,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'grupoEmpresarialId': grupoEmpresarialId,
//       'grupoEmpresarialDesc': grupoEmpresarialDesc,
//       'lojaId': lojaId,
//       'lojaDesc': lojaDesc,
//       'fornecedorId': fornecedorId,
//       'fornecedorDesc': fornecedorDesc,
//       // ... outras propriedades
//       'notas': notas.map((nota) => nota.toJson()).toList(),
//     };
//   }
// }
