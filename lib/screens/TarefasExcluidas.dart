import 'package:flutter/material.dart';

import '../Conexoes/ServiceTarefas.dart';
import 'TarefaFinalizada.dart';

class TarefasExcluidas extends StatefulWidget {
  var token;
  TarefasExcluidas({Key? key, required this.token}) : super(key: key);

  @override
  State<TarefasExcluidas> createState() => _TarefasExcluidasState();
}

class _TarefasExcluidasState extends State<TarefasExcluidas> {
  var serviceTarefa = ServiceTarefas();
  late Future<List> todasTarefasFinalizadas;

  @override
  void initState() {
    super.initState();
    todasTarefasFinalizadas = serviceTarefa.pegarTarefasExcluidas(widget.token);
  }

  Future<void> _recarregaLista() async {
    setState(() {
      todasTarefasFinalizadas =
          serviceTarefa.pegarTarefasExcluidas(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    var listTarefas = serviceTarefa.pegarTarefasExcluidas(widget.token);

    return FutureBuilder<List>(
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
                var dia = serviceTarefa.extraiDiaDaDataExclusao(tarefa);

                return Card(
                  child: ListTile(
                    onTap: () async {
                      // bool retorno;
                      // try {
                      //   retorno = await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => TarefaFinalizada(
                      //           tarefa: tarefa, token: widget.token),
                      //     ),
                      //   );
                      // } catch (ex) {
                      //   retorno = false;
                      // }
                      // if (retorno) {
                      //   setState(() {
                      //     todasTarefasFinalizadas =
                      //         serviceTarefa.pegarTarefasExcluidas(widget.token);
                      //   });
                      // }
                    },
                    leading: Stack(
                      children: [
                        const Icon(Icons.calendar_today, size: 50),
                        Positioned(
                          right: 0,
                          bottom: -5,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: Text(
                                dia,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(tarefa['titulo']),
                    // ignore: prefer_interpolation_to_compose_strings
                    subtitle: Text('Excluida em ' + tarefa['dataExclusao']),
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
    );
  }
}
