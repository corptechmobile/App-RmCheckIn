import 'package:flutter/material.dart';

enum NFCompraStatusEnum {
  REGISTRANDO,
  RECEBIDA,
  ENTRADA_NAO_AUTORIZADA,
  AGUARDANDO_AUTORIZACAO_ENTRADA,
  ENTRADA_AUTORIZADA,
  VEICULO_NO_PATIO,
  EM_CONFERENCIA,
  CONFERENCIA_FINALIZADA,
  FINALIZADO,
  CANCELADO,
  AGUARDANDO_LIBERACAO,
  G,
  AGUARDANDO_VALIDACAO_NFS,
}

NFCompraStatusEnum getStatusNotaFromString(String statusDesc) {
  switch (statusDesc) {
    case 'REGISTRANDO':
      return NFCompraStatusEnum.REGISTRANDO;
    case 'AGUARDANDO_VALIDACAO_NFS':
      return NFCompraStatusEnum.AGUARDANDO_VALIDACAO_NFS;
    case 'RECEBIDA':
      return NFCompraStatusEnum.RECEBIDA;
    case 'ENTRADA_NAO_AUTORIZADA':
      return NFCompraStatusEnum.ENTRADA_NAO_AUTORIZADA;
    case 'AGUARDANDO_AUTORIZACAO_ENTRADA':
      return NFCompraStatusEnum.AGUARDANDO_AUTORIZACAO_ENTRADA;
    case 'ENTRADA_AUTORIZADA':
      return NFCompraStatusEnum.ENTRADA_AUTORIZADA;
    case 'VEICULO_NO_PATIO':
      return NFCompraStatusEnum.VEICULO_NO_PATIO;
    case 'EM_CONFERENCIA':
      return NFCompraStatusEnum.EM_CONFERENCIA;
    case 'CONFERENCIA_FINALIZADA':
      return NFCompraStatusEnum.CONFERENCIA_FINALIZADA;
    case 'FINALIZADO':
      return NFCompraStatusEnum.FINALIZADO;
    case 'CANCELADO':
      return NFCompraStatusEnum.CANCELADO;
    case 'G':
      return NFCompraStatusEnum.G;
    case 'AGUARDANDO_LIBERACAO':
      return NFCompraStatusEnum.AGUARDANDO_LIBERACAO;
    default:
      throw Exception('Unknown status: $statusDesc');
  }
}

Color getStatusColor(NFCompraStatusEnum statusDesc) {
  switch (statusDesc) {
    case NFCompraStatusEnum.REGISTRANDO:
      return Color(0xff17a2b8);
    // case NFCompraStatusEnum.RECEBIDA:
    //   return Colors.pink.shade400;
    case NFCompraStatusEnum.AGUARDANDO_VALIDACAO_NFS:
      return Color(0xffdc3545);
    case NFCompraStatusEnum.ENTRADA_NAO_AUTORIZADA:
      return Color.fromARGB(255, 153, 0, 255);
    case NFCompraStatusEnum.AGUARDANDO_AUTORIZACAO_ENTRADA:
      return Color(0xffffc107);
    case NFCompraStatusEnum.ENTRADA_AUTORIZADA:
      return Color(0xff28a745);
    case NFCompraStatusEnum.VEICULO_NO_PATIO:
      return Color(0xff17a2b8);
    // case NFCompraStatusEnum.G:
    //   return Colors.orange;
    case NFCompraStatusEnum.EM_CONFERENCIA:
      return Color(0xff17a2b8);
    case NFCompraStatusEnum.CONFERENCIA_FINALIZADA:
      return Color(0xff28a745);
    case NFCompraStatusEnum.FINALIZADO:
      return Color(0xff17a2b8);
    case NFCompraStatusEnum.CANCELADO:
      return Color(0xffdc3545);
    // case NFCompraStatusEnum.AGUARDANDO_LIBERACAO:
    //   return Colors.brown;
    case NFCompraStatusEnum.AGUARDANDO_VALIDACAO_NFS:
      return Color(0xffffc107);
    default:
      return Colors.black;
  }
}

IconData getStatusIcon(NFCompraStatusEnum statusDesc) {
  switch (statusDesc) {
    case NFCompraStatusEnum.REGISTRANDO:
      return Icons.edit;
    // case NFCompraStatusEnum.RECEBIDA:
    //   return Colors.pink.shade400;
    case NFCompraStatusEnum.ENTRADA_NAO_AUTORIZADA:
      return Icons.local_shipping;
    case NFCompraStatusEnum.AGUARDANDO_AUTORIZACAO_ENTRADA:
      return Icons.back_hand;
    case NFCompraStatusEnum.ENTRADA_AUTORIZADA:
      return Icons.local_shipping;
    case NFCompraStatusEnum.VEICULO_NO_PATIO:
      return Icons.local_shipping;
    // case NFCompraStatusEnum.G:
    //   return Colors.orange;
    case NFCompraStatusEnum.EM_CONFERENCIA:
      return Icons.contact_phone;
    case NFCompraStatusEnum.CONFERENCIA_FINALIZADA:
      return Icons.check_box_outlined;
    case NFCompraStatusEnum.FINALIZADO:
      return Icons.check;
    case NFCompraStatusEnum.CANCELADO:
      return Icons.not_interested;
    // case NFCompraStatusEnum.AGUARDANDO_LIBERACAO:
    //   return Colors.brown;

    case NFCompraStatusEnum.AGUARDANDO_VALIDACAO_NFS:
      return Icons.back_hand;

    default:
      return Icons.question_mark;
  }
}