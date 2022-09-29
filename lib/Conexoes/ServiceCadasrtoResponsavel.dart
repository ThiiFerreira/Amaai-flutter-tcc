import '../models/CadastroUsuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceCadasrtoResponsavel {
  void criaCadastro(CadastroUsuario cadastro, BuildContext context) async {
    var response = await _realizaCadastro(cadastro);
    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      var code = json[0]['message'];

      var snackBar = const SnackBar(
        content: Text('Cadastro do responsavel realizado com sucesso!'),
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else if (response.statusCode == 500) {
      var mensagem = json[0]['message'].toString();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    } else {
      var mensagem = json['errors']['RePassword'].toString();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaCadastro(CadastroUsuario cadastro) async {
    var headers = {'Content-Type': 'Application/json'};

    var cadastroJson = jsonEncode({
      "username": cadastro.Username,
      "Email": cadastro.Email,
      "Password": cadastro.Senha,
      "RePassword": cadastro.Confsenha,
      "Nome": cadastro.Nome,
      "Cpf": cadastro.Cpf,
      "DataNascimento": cadastro.DataNasc,
      "Telefone": cadastro.Telefone,
      "Endereco": cadastro.Endereco
    });
    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/cadastro");
    var response = await http.post(url, headers: headers, body: cadastroJson);

    return response;
  }
}
