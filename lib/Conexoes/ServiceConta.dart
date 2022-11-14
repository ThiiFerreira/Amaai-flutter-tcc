import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/DadosDaContaLista.dart';
import 'package:flutter_application_1/screens/DadosDaContaPage.dart';
import 'package:flutter_application_1/screens/HomePage.dart';
import 'package:http/http.dart' as http;

import '../components/AlertaMensagem.dart';
import '../models/Token.dart';
import '../screens/LoginPage.dart';

class ServiceConta {
  Future<void> excluirContaResponsavel(
      String senha, String token, BuildContext context) async {
    var login = ConverteToken(token).ConverteTokenParaNomeUsuario();

    var response = await _realizaDeleteContaResponsavel(login, senha, token);

    if (response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('Conta excluida com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //Navigator.pop(context, true);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DadosDaConta(token: token),
        ),
      );
    } else {
      //var json = jsonDecode(utf8.decode(response.bodyBytes));

      var mensagem = response.body.toString();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaDeleteContaResponsavel(
      String login, String senha, String token) async {
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var json = jsonEncode({"username": login, "password": senha});

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/dados/responsavel");

    var response = await http.delete(url, headers: headers, body: json);

    return response;
  }

  Future<void> excluirContaAssistido(
      String senha, String token, BuildContext context) async {
    var login = ConverteToken(token).ConverteTokenParaNomeUsuario();

    var response = await _realizaDeleteContaAssistido(login, senha, token);

    if (response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('Conta excluida com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //Navigator.pop(context, true);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token)),
      );
    } else {
      //var json = jsonDecode(utf8.decode(response.bodyBytes));

      var mensagem = response.body.toString();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaDeleteContaAssistido(
      String login, String senha, String token) async {
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var json = jsonEncode({"username": login, "password": senha});

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/dados/assistido");

    var response = await http.delete(url, headers: headers, body: json);

    return response;
  }
}
