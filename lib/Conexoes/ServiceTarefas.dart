import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/screens/tarefas.page.dart';
import 'package:intl/intl.dart';
import '../Conexoes/mensagemWpp.dart';
import '../models/Tarefa.dart';
import '../models/Token.dart';
import '../screens/AletaTarefaPage.dart';

class ServiceTarefas {
  late BuildContext _context;

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

  void mostraMensagem(Tarefa tarefa) {
    print("Hehehe hora de fazer a tarefa");
    AlertaMensagem(mensagem: "hora de fazer a pohha da tarefa");
  }

  void criaTarefa(Tarefa tarefa, String token, BuildContext context) async {
    var id = ConverteToken(token).ConverteTokenParaId();
    var response = await _realizaPostTarefa(tarefa, token);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      var mensagem = json[0]["message"].toString();
      int segundosParaDisperta = _criaTimer(tarefa);
      segundosParaDisperta = segundosParaDisperta + 1;

      var snackBar = SnackBar(
        content: Text(mensagem),
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
      var mensagem = "Falha ao criar tarefa";

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

  int verificaSeTarefaEstaAtrasada(tarefa) {
    DateTime now = DateTime.now();
    var data = DateFormat('yyyy-MM-dd').format(now);
    now = DateTime.parse(data);

    DateTime now2 = DateTime(
        int.tryParse(tarefa['dataAlerta'].toString().substring(6, 10))!,
        int.tryParse(tarefa['dataAlerta'].toString().substring(3, 5))!,
        int.tryParse(tarefa['dataAlerta'].toString().substring(0, 2))!);
    int atrasada = now.compareTo(now2);

    if (atrasada == 0) {
      int horaTarefa =
          int.tryParse(tarefa['horaAlerta'].toString().substring(0, 2))!;
      int minTarefa =
          int.tryParse(tarefa['horaAlerta'].toString().substring(3, 5))!;
      var horaAtual = TimeOfDay.now();

      if (horaAtual.hour > horaTarefa) {
        atrasada = 1;
      }
      if (horaAtual.hour == horaTarefa && horaAtual.minute > minTarefa) {
        atrasada = 1;
      }
    }
    return atrasada;
  }

  int _criaTimer(Tarefa tarefa) {
    int anoTarefa =
        int.tryParse(tarefa.dataAlerta.toString().substring(6, 10))!;

    int mesTarefa = int.tryParse(tarefa.dataAlerta.toString().substring(3, 5))!;

    int diaTarefa = int.tryParse(tarefa.dataAlerta.toString().substring(0, 2))!;

    int horaTarefa =
        int.tryParse(tarefa.horaAlerta.toString().substring(0, 2))!;

    int minTarefa = int.tryParse(tarefa.horaAlerta.toString().substring(3, 5))!;

    final dataCriacao = DateTime.now();
    final dataTarefa =
        DateTime(anoTarefa, mesTarefa, diaTarefa, horaTarefa, minTarefa);

    final diferenca = dataTarefa.difference(dataCriacao);

    return diferenca.inSeconds;
  }
}
