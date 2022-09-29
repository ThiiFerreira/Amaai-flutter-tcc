import 'package:flutter/material.dart';
import '../Conexoes/ServiceTarefas.dart';
import '../components/CampoData.dart';
import '../components/CampoHora.dart';
import '../components/CampoPreenchimento.dart';
import '../models/Tarefa.dart';

class CriarTarefa extends StatefulWidget {
  var token;
  var tarefa = null;
  CriarTarefa({Key? key, required this.token, this.tarefa}) : super(key: key);

  @override
  State<CriarTarefa> createState() => _CriarTarefaState();
}

class _CriarTarefaState extends State<CriarTarefa> {
  var serviceTarefas = ServiceTarefas();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController controladorCampoTitulo = TextEditingController();
  final TextEditingController controladorCampoDescricao =
      TextEditingController();
  final TextEditingController controladorCampoHoraAlerta =
      TextEditingController();
  final TextEditingController controladorCampoDataAlerta =
      TextEditingController();

  bool carregando = false;

  void limpaControladores() {
    controladorCampoTitulo.text = '';
    controladorCampoDescricao.text = '';
    controladorCampoHoraAlerta.text = '';
    controladorCampoDataAlerta.text = '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tarefa != null) {
      controladorCampoTitulo.text = widget.tarefa['titulo'].toString();
      controladorCampoDescricao.text = widget.tarefa['descricao'].toString();
      controladorCampoHoraAlerta.text = widget.tarefa['horaAlerta'].toString();
      controladorCampoDataAlerta.text = widget.tarefa['dataAlerta'].toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar tarefa'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CampoPreenchimento(
                    controlador: controladorCampoTitulo,
                    rotulo: "Titulo",
                    dica: 'Ex. Dar comida para o rex',
                  ),
                  CampoPreenchimento(
                    controlador: controladorCampoDescricao,
                    rotulo: 'Descrição',
                    dica: 'Ex. Colocar 2 copo de ração',
                  ),
                  CampoHora(
                      controlador: controladorCampoHoraAlerta,
                      rotulo: 'Hora do alerta'),
                  CampoData(
                    controlador: controladorCampoDataAlerta,
                    rotulo: 'Data do alarme',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 16.0, 8.0, 16.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 15,
                          ),
                          child: const Text(
                            'CANCELAR',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 16.0, 60.0, 16.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            elevation: 15,
                          ),
                          child: const Text(
                            'LIMPAR',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            limpaControladores();
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0),
                        child: carregando
                            ? CircularProgressIndicator()
                            : TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  elevation: 15,
                                ),
                                child: const Text(
                                  'SALVAR',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  var formValid =
                                      _formKey.currentState?.validate() ??
                                          false;
                                  if (formValid) {
                                    setState(() {
                                      carregando = true;
                                    });

                                    Tarefa tarefa = Tarefa(
                                        controladorCampoTitulo.text,
                                        controladorCampoDescricao.text,
                                        controladorCampoHoraAlerta.text,
                                        controladorCampoDataAlerta.text);

                                    if (widget.tarefa != null) {
                                      serviceTarefas.atualizaTarefa(
                                          tarefa,
                                          widget.token,
                                          widget.tarefa['id'].toString(),
                                          context);
                                    } else {
                                      serviceTarefas.criaTarefa(
                                          tarefa, widget.token, context);
                                    }
                                    await Future.delayed(Duration(seconds: 2));

                                    setState(() {
                                      carregando = false;
                                    });
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
