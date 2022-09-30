import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/tarefa.page.dart';
import 'package:intl/intl.dart';
import '../Conexoes/ServiceTarefas.dart';
import '../models/Token.dart';
import 'CriarTarefaPage.dart';
import 'HomePage.dart';

// ignore: must_be_immutable

class TarefasPage extends StatefulWidget {
  var token;
  TarefasPage({Key? key, required this.token});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  late Future<List> todasTarefas;

  var _serviceTarefas = ServiceTarefas();

  @override
  void initState() {
    super.initState();
    todasTarefas = _serviceTarefas.pegarTarefas(widget.token);
  }

  Future<void> _recarregaLista() async {
    setState(() {
      todasTarefas = _serviceTarefas.pegarTarefas(widget.token);
    });
  }

  int comparaDatas(tarefa) {
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

  @override
  Widget build(BuildContext context) {
    String role = ConverteToken(widget.token).ConverteTokenParaRole();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: widget.token),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas'),
        ),
        body: FutureBuilder<List>(
          future: todasTarefas,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar tarefas'),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data! == null || snapshot.data!.length == 0) {
                return const Center(
                  child: Text('Não existe tarefas'),
                );
              }
              return RefreshIndicator(
                onRefresh: _recarregaLista,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var tarefa = snapshot.data![index];
                    var subtitle =
                        '${'Hora: ' + tarefa['horaAlerta']}, Data: ' +
                            tarefa['dataAlerta'];

                    var atrasada = comparaDatas(tarefa);

                    return Card(
                      child: ListTile(
                        onTap: () async {
                          bool retorno = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TarefaPage(
                                  tarefa: tarefa, token: widget.token),
                            ),
                          );
                          if (retorno) {
                            setState(() {
                              todasTarefas =
                                  _serviceTarefas.pegarTarefas(widget.token);
                            });
                          }
                        },
                        leading: const Icon(Icons.calendar_today, size: 50),
                        title: Text(
                          tarefa['titulo'],
                        ),
                        // ignore: prefer_interpolation_to_compose_strings
                        subtitle: atrasada > 0
                            ? Text(
                                "ATRASADA - $subtitle",
                                style: const TextStyle(color: Colors.red),
                              )
                            : Text(subtitle),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: role == "responsavel"
            ? FloatingActionButton(
                onPressed: () async {
                  bool criou = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CriarTarefa(token: widget.token),
                    ),
                  );
                  if (criou) {
                    setState(() {
                      todasTarefas = _serviceTarefas.pegarTarefas(widget.token);
                    });
                  }
                },
                tooltip: 'Criar tarefa',
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
