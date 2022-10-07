// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/tarefa.page.dart';
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

  var serviceTarefas = ServiceTarefas();

  bool carregando = false;

  @override
  void initState() {
    super.initState();
    todasTarefas = serviceTarefas.pegarTarefas(widget.token);
  }

  Future<void> _recarregaLista() async {
    setState(() {
      todasTarefas = serviceTarefas.pegarTarefas(widget.token);
    });
  }

  Future<void> excluirTarefaRapido(String id) async {
    Widget cancelaButton = FlatButton(
      child: const Text("CANCELAR"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget okButton = FlatButton(
      child: const Text("OK"),
      onPressed: () async {
        serviceTarefas.excluirTarefa(id, widget.token, context);
        print("tinha que esta aqui antes");
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tem certeza?"),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            cancelaButton,
            okButton,
          ],
        );
      },
    );
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
                        // ignore: prefer_interpolation_to_compose_strings
                        '${'Hora: ' + tarefa['horaAlerta']}, Data: ' +
                            tarefa['dataAlerta'];

                    var atrasada =
                        serviceTarefas.verificaSeTarefaEstaAtrasada(tarefa);

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
                                  serviceTarefas.pegarTarefas(widget.token);
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
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.red,
                            elevation: 0,
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Tem certeza?"),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  actions: [
                                    FlatButton(
                                      child: const Text("CANCELAR"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      child: const Text("OK"),
                                      onPressed: () async {
                                        serviceTarefas
                                            .excluirTarefa(
                                                tarefa['id'].toString(),
                                                widget.token,
                                                context)
                                            .then((value) => _recarregaLista());
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Icon(Icons.delete),
                        ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CriarTarefa(token: widget.token),
                    ),
                  );
                },
                tooltip: 'Criar tarefa',
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
