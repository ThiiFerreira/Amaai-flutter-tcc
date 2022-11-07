import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screens/RealizaResetPage.dart';
import '../screens/LoginPage.dart';

class ServiceResetSenha {
  void solicitarResetSenha(DadosResetSenha reset, BuildContext context) async {
    reset.codigoVerificacao = _gerarNumero();
    var response = await _solitarResetSenha(reset);
    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      String token = json[0]['message'].toString();
      var snackBar = const SnackBar(
        content: Text('Email com o codigo de verificação enviado!'),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RealizaReset(
              codigoVerificacao: reset.codigoVerificacao,
              email: reset.email,
              token: token),
        ),
      );
    } else {
      var mensagem = json[0]['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _solitarResetSenha(DadosResetSenha reset) async {
    var headers = {
      'Content-Type': 'Application/json',
    };
    var resetJson = jsonEncode(
        {"email": reset.email, "CodigoVerificacao": reset.codigoVerificacao});
    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/solicita-reset");
    var response = await http.post(url, headers: headers, body: resetJson);
    return response;
  }

  void realizaResetSenha(camposReset reset, BuildContext context) async {
    var response = await _realizaResetSenha(reset);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      var mensagem = json[0]['message'].toString();

      var snackBar = SnackBar(
        content: Text(mensagem),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } else {
      var mensagem = "Falha ao redefinir senha";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaResetSenha(camposReset reset) async {
    var headers = {
      'Content-Type': 'Application/json',
    };
    var resetJson = jsonEncode({
      "email": reset.email,
      "Password": reset.Password,
      "RePassword": reset.RePassword,
      "Token": reset.token,
    });
    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/efetua-reset");
    var response = await http.post(url, headers: headers, body: resetJson);
    return response;
  }
}

int _gerarNumero() {
  int numero = 0;
  Random numeroAleatorio = Random();
  numero = numeroAleatorio.nextInt(1000);
  return numero;
}

class camposReset {
  final String email;
  final String Password;
  final String RePassword;
  final String token;

  camposReset(this.email, this.Password, this.RePassword, this.token);
}

class DadosResetSenha {
  late String email;
  late int codigoVerificacao;
}
