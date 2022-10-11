import 'package:flutter/material.dart';
import '../Conexoes/ServiceTarefas.dart';
import 'HomePage.dart';
import 'TarefaFinalizada.dart';

class HistoricoTarefas extends StatefulWidget {
  var token;
  HistoricoTarefas({Key? key, required this.token}) : super(key: key);

  @override
  State<HistoricoTarefas> createState() => _HistoricoTarefasState();
}

class _HistoricoTarefasState extends State<HistoricoTarefas> {
  var serviceTarefa = ServiceTarefas();

  late Future<List> todasTarefasFinalizadas;

  @override
  void initState() {
    super.initState();
    todasTarefasFinalizadas =
        serviceTarefa.pegarTarefasFinalizads(widget.token);
  }

  Future<void> _recarregaLista() async {
    setState(() {
      todasTarefasFinalizadas =
          serviceTarefa.pegarTarefasFinalizads(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    var listTarefas = serviceTarefa.pegarTarefasFinalizads(widget.token);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: widget.token),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas finalizadas'),
        ),
        body: FutureBuilder<List>(
          future: listTarefas,
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
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          bool retorno;
                          try {
                            retorno = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TarefaFinalizada(
                                    tarefa: tarefa, token: widget.token),
                              ),
                            );
                          } catch (ex) {
                            retorno = false;
                          }
                          if (retorno) {
                            setState(() {
                              todasTarefasFinalizadas = serviceTarefa
                                  .pegarTarefasFinalizads(widget.token);
                            });
                          }
                        },
                        leading: const Icon(Icons.event_available,
                            color: Colors.green, size: 50),
                        title: Text(tarefa['titulo']),
                        // ignore: prefer_interpolation_to_compose_strings
                        subtitle:
                            Text('Finalizada em ' + tarefa['dataFinalizacao']),
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
      ),
    );
  }
}
