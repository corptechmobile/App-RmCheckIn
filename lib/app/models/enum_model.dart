class RMCCheckInStatusEnum {
  // ignore: constant_identifier_names
  static const RMCCheckInStatusEnum REGISTRANDO =
      // ignore: unnecessary_const
      const RMCCheckInStatusEnum._("Registrando Check-In", "fa fa-edit", "alert alert-info", "text-info", "", "Registrando", "", 0);
  static const RMCCheckInStatusEnum AGUARDANDO_VALIDACAO_NFS = const RMCCheckInStatusEnum._(
      "Aguardando Validação das NF-e's", "fa fa-hourglass-half", "alert alert-warning", "text-warning", "", "Valid. NF-e's", "#fff3cd", 1);
  // ignore: unnecessary_const
  static const RMCCheckInStatusEnum ENTRADA_NAO_AUTORIZADA = const RMCCheckInStatusEnum._(
      "Entrada Não Autorizada", "fa fa-truck", "alert alert-danger", "text-danger", "table-tr-danger", "Não Autorizado", "#f8d7da", 2);
  static const RMCCheckInStatusEnum AGUARDANDO_AUTORIZACAO_ENTRADA = const RMCCheckInStatusEnum._("Aguardando Autorização de Entrada", "fa fa-hand-paper-o",
      "alert alert-warning", "text-warning", "table-tr-warning", "Aguard. Autorização", "#fff3cd", 3);
  static const RMCCheckInStatusEnum ENTRADA_AUTORIZADA = const RMCCheckInStatusEnum._(
      "Entrada Autorizada", "fa fa-truck", "alert alert-success", "text-success", "table-tr-success", "Ent. Autorizada", "#d4edda", 4);
  static const RMCCheckInStatusEnum VEICULO_NO_PATIO =
      const RMCCheckInStatusEnum._("Veículo no Pátio", "fa fa-truck", "alert alert-info", "text-info", "table-tr-info", "Veículo no Pátio", "#d1ecf1", 5);
  static const RMCCheckInStatusEnum EM_CONFERENCIA =
      const RMCCheckInStatusEnum._("Em Conferência", "fa fa-cubes", "alert alert-info", "text-info", "table-tr-info", "Em Conferência", "#d1ecf1", 6);
  static const RMCCheckInStatusEnum CONFERENCIA_FINALIZADA = const RMCCheckInStatusEnum._(
      "Conferência Finalizada", "fa fa-check-square-o", "alert alert-success", "text-success", "table-tr-success", "Conferência Finalizada", "#d1ecf1", 7);
  static const RMCCheckInStatusEnum FINALIZADO =
      const RMCCheckInStatusEnum._("Finalizado", "fa fa-check", "alert alert-info", "text-info", "table-tr-info", "Finalizado", "#d1ecf1", 8);
  static const RMCCheckInStatusEnum CANCELADO =
      const RMCCheckInStatusEnum._("Cancelado", "fa fa-ban", "alert alert-danger", "text-danger", "table-tr-danger", "Cancelado", "#f8d7da", 9);

  final String descricao;
  final String iconClass;
  final String alertClass;
  final String textClass;
  final String trClass;
  final String textResum;
  final String color;
  final int ordem;

  const RMCCheckInStatusEnum._(this.descricao, this.iconClass, this.alertClass, this.textClass, this.trClass, this.textResum, this.color, this.ordem);
}
