import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/screens/tarefas.page.dart';
import '../Conexoes/mensagemWpp.dart';
import '../models/Tarefa.dart';
import '../models/Token.dart';

class ServiceTarefas {
  Future<List> pegarTarefas(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa");
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Erro ao carregar tarefas");
    }
  }

  Future<List> pegarTarefasFinalizads(String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/tarefa/finalizadas");
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Erro ao carregar tarefas");
    }
  }

  void criaTarefa(Tarefa tarefa, String token, BuildContext context) async {
    var conexaoComOWpp = ConexaoComOWpp();

    var id = ConverteToken(token).ConverteTokenParaId();
    var response = await _realizaPostTarefa(tarefa, token);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 201) {
      String mensagem =
          "Uma tarefa foi criada para ser feita as ${tarefa.horaAlerta} no dia ${tarefa.dataAlerta}, não esqueça de realiza-lá 😁";
      //conexaoComOWpp.enviarMensagemParaOWhatsAppIdoso(token, id, mensagem);

      var snackBar = const SnackBar(
        content: Text('Tarefa criada com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TarefasPage(token: token),
        ),
      );
    } else {
      var mensagem = json['errors']['Descricao'][0].toString();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaPostTarefa(Tarefa tarefa, String token) async {
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode({
      "titulo": tarefa.titulo,
      "descricao": tarefa.descricao,
      "horaAlerta": tarefa.horaAlerta,
      "dataAlerta": tarefa.dataAlerta,
    });

    var url = Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa");
    var response = await http.post(url, headers: headers, body: cadastroJson);

    return response;
  }

  void atualizaTarefa(
      Tarefa tarefa, String token, String id, BuildContext context) async {
    var response = await _realizaPutTarefa(tarefa, token, id);

    if (response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('Tarefa atualizada com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TarefasPage(token: token),
        ),
      );
    } else {
      var mensagem = "Erro ao atualizar tarefa";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaPutTarefa(
      Tarefa tarefa, String token, String id) async {
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };

    var cadastroJson = jsonEncode(
      {
        "titulo": tarefa.titulo,
        "descricao": tarefa.descricao,
        "horaAlerta": tarefa.horaAlerta,
        "DataAlerta": tarefa.dataAlerta,
      },
    );

    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa/$id");
    var response = await http.put(url, headers: headers, body: cadastroJson);

    return response;
  }

  void excluirTarefa(String id, String token, BuildContext context) async {
    var response = await _realizaDeleteTarefa(id, token);

    if (response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('Tarefa excluida com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //Navigator.pop(context, true);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      var mensagem = 'Erro ao excluir tarefa';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaDeleteTarefa(String id, String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url =
        Uri.parse("https://app-tcc-amai-producao.herokuapp.com/tarefa/$id");

    var response = await http.delete(url, headers: headers);

    return response;
  }

  void finalizaTarefa(String id, String token, BuildContext context) async {
    var response = await _realizaAtualizacaoParaFinalizarTarefa(id, token);

    if (response.statusCode == 204) {
      var snackBar = const SnackBar(
        content: Text('Tarefa finalizada com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      var mensagem = 'Erro ao excluir tarefa';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  Future<http.Response> _realizaAtualizacaoParaFinalizarTarefa(
      String id, String token) async {
    var headers = {'Authorization': 'Bearer $token'};

    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/tarefa/$id/finalizar");

    var response = await http.put(url, headers: headers);

    return response;
  }

  void _verificaSeTarefaEstaAtrasada(Tarefa tarefa) {}
}
