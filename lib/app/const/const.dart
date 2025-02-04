class ConstsApi {
  static const String baseUrl = 'http://acesso.triviacloud.com.br';
  //static const String baseUrl = 'http://177.207.241.213:8090';
  //static const String baseUrl = 'http://192.168.15.160:8090';
  static const String motoristaAuth = '$baseUrl/api/auth/motorista';
  static const String basicAuth = 'Basic bGVvbmFyZG86MTIzNDU2';
  static const String verificarToken = '$baseUrl/api/motorista/token/sms';
  static const String registrarUser = '$baseUrl/api/motorista/registrar';
  static const String digitarNovaSenha = '$baseUrl/api/auth/motorista/alterar-senha';
  static const String uploadFoto = '$baseUrl/api/motorista/cadastro/upload';
  static const String finalizarRegistro = '$baseUrl/api/motorista/cadastro';
  static const String registrarVeiculo = '$baseUrl/api/motorista/veiculo/registrar';
  static const String meusDados = '$baseUrl/api/motorista/meus-dados';
  static const String tipoVeiculo = '$baseUrl/api/tipoveiculo';
  static const String lojasCheckin = '$baseUrl/api/motorista/lojas/checkin';
  static const String registrarCheckin = '$baseUrl/api/motorista/checkin/registrar';
  static const String verificarCpf = '$baseUrl/api/motorista/verificar/registro';
  static const String concluirCheckin = '$baseUrl/api/motorista/checkin/concluir';
  static const String statusService = '$baseUrl/api/motorista/checkin/status';
  static const String inativarUser = '$baseUrl/api/motorista/inativar';
  static const String excluirNF = '$baseUrl/api/motorista/checkin/excluir/nf';
  static const String esqueciMinhaSenhaEmail = "$baseUrl/api/motorista/esqueci-minha-senha/email";
  static const String esqueciMinhaSenha = '$baseUrl/api/motorista/esqueci-minha-senha/telefone';
  static const String esqueciMinhaSenhaToken = '$baseUrl/api/motorista/esqueci-minha-senha/token/telefone';
  static const String esqueciMinhaSenhaTokenEmail = '$baseUrl/api/motorista/esqueci-minha-senha/token/email';
  static const String alterarMinhaSenha = '$baseUrl/api/motorista/alterar-senha';
  static const String redefinirDados = '$baseUrl/api/motorista/meus-dados';
  static const String alterarSenha = '$baseUrl/api/motorista/meus-dados/alterar-senha';
  static const String alerarSenhaAuthEsqueci = '$baseUrl/api/auth/motorista/alterar-senha';
}
