class CPFUtils {
  static bool cpfValido(String cpf) {
    if (cpf != null) {
      cpf = limpar(cpf);
    }

    if (cpf == null || cpf.length != 11 || isCPFPadrao(cpf)) {
      return false;
    }

    try {
      int.parse(cpf);
    } catch (FormatException) {
      return false;
    }

    return verificar(cpf.substring(0, 9)) == cpf.substring(9, 11);
  }

  static bool isCPFPadrao(String cpf) {
    return cpf == "11111111111" ||
        cpf == "22222222222" ||
        cpf == "33333333333" ||
        cpf == "44444444444" ||
        cpf == "55555555555" ||
        cpf == "66666666666" ||
        cpf == "77777777777" ||
        cpf == "88888888888" ||
        cpf == "99999999999";
  }

  static String verificar(String num) {
    int primDig, segDig;
    int soma = 0, peso = 10;
    for (int i = 0; i < num.length; i++) {
      soma += int.parse(num[i]) * peso--;
    }

    if (soma % 11 == 0 || soma % 11 == 1) {
      primDig = 0;
    } else {
      primDig = 11 - (soma % 11);
    }

    soma = 0;
    peso = 11;
    for (int i = 0; i < num.length; i++) {
      soma += int.parse(num[i]) * peso--;
    }

    soma += primDig * 2;
    if (soma % 11 == 0 || soma % 11 == 1) {
      segDig = 0;
    } else {
      segDig = 11 - (soma % 11);
    }

    return primDig.toString() + segDig.toString();
  }

  static String limpar(String value) {
    String cpf = value;
    if (value != null && value.isNotEmpty) {
      cpf = value.replaceAll(RegExp(r'\.|-|,'), '');
    }

    return cpf;
  }

  static String mascara(String value) {
    try {
      String cpf = value;
      if (cpf != null && cpf.length == 11) {
        cpf = cpf.substring(0, 3) + '.' + cpf.substring(3, 6) + '.' + cpf.substring(6, 9) + '-' + cpf.substring(9, 11);
      }
      return cpf;
    } catch (e) {
      print(e);
      return value;
    }
  }

  static String escondido(String value) {
    try {
      String cpf = value;
      if (cpf != null && cpf.length > 11) {
        cpf = limpar(cpf);
      }
      if (cpf != null && cpf.length == 11) {
        cpf = cpf.substring(0, 3) + '.' + cpf.substring(3, 6) + '.***-**';
      }
      return cpf;
    } catch (e) {
      print(e);
      return '***.***.***-**';
    }
  }
}
