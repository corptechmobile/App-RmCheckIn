import 'package:flutter/material.dart';

void _showDocumentScannerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Scanner de Documentos'),
        content: Text('Adicione aqui o conteúdo do scanner de documentos.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Fechar'),
          ),
          // Adicione mais botões ou funcionalidades conforme necessário
        ],
      );
    },
  );
}
