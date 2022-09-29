import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/DadosCadastraisAtualizados.dart';

class ServiceEdicaoDados {
  Future<http.Response> recuperaDados(String id, String token) async {
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/RecuperaEAtualizaDados/$id");
    var response = await http.get(url, headers: headers);

    return response;
  }

  Future<http.Response> realizaUpdateDeDados(
      DadosAtualizados dados, String id, String token) async {
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode({
      "username": dados.username,
      "email": dados.email,
      "nome": dados.nome,
      "cpf": dados.cpf,
      "dataNascimento": dados.dataNascimento,
      "telefone": dados.telefone,
      "endereco": dados.endereco
    });

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/RecuperaEAtualizaDados/$id");
    var response = await http.put(url, headers: headers, body: cadastroJson);

    return response;
  }
}
