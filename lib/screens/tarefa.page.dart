// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

import '../Conexoes/ServiceTarefas.dart';
import '../models/Token.dart';
import 'CriarTarefaPage.dart';

// ignore: must_be_immutable
class TarefaPage extends StatefulWidget {
  Map<String, dynamic> tarefa;
  var token;
  TarefaPage({Key? key, required this.tarefa, this.token}) : super(key: key);

  @override
  State<TarefaPage> createState() => _TarefaPageState();
}

class _TarefaPageState extends State<TarefaPage> {
  var serviceTarefa = ServiceTarefas();

  bool isSpeaking = false;
  final TextEditingController _controller = TextEditingController();
  final _flutterTts = FlutterTts();

  void initializeTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    _flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
    _flutterTts.setLanguage("pt-br");
  }

  @override
  void initState() {
    super.initState();
    initializeTts();
  }

  void speak() async {
    await _flutterTts.speak(widget.tarefa['titulo']);
  }

  void stop() async {
    await _flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  bool _reproduzSom = true;
  bool carregandoExcluir = false;
  bool carregandoFinalizar = false;

  @override
  Widget build(BuildContext context) {
    if (_reproduzSom) {
      speak();
      _reproduzSom = false;
    }

    int hora =
        int.tryParse(widget.tarefa['horaAlerta'].toString().substring(0, 2))!;
    int min =
        int.tryParse(widget.tarefa['horaAlerta'].toString().substring(3, 5))!;
    print(widget.tarefa['horaAlerta']);
    print(hora);
    print(min);

    String role = ConverteToken(widget.token).ConverteTokenParaRole();

    return Scaffold(
      appBar: AppBar(title: Text('Tarefa')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.fromBorderSide(
                            BorderSide(
                                width: 4,
                                color: Colors.black,
                                style: BorderStyle.solid), //BorderSide
                          )),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                widget.tarefa['horaAlerta'],
                                style: TextStyle(fontSize: 30),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              Text(
                                widget.tarefa['dataAlerta'],
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        border: Border.fromBorderSide(
                          BorderSide(
                              width: 4,
                              color: Colors.black,
                              style: BorderStyle.solid), //BorderSide
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                widget.tarefa['titulo'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              if (widget.tarefa['descricao'] != null)
                                Text(
                                  widget.tarefa['descricao'],
                                  style: TextStyle(fontSize: 25),
                                  textAlign: TextAlign.left,
                                ),
                              ElevatedButton(
                                onPressed: () {
                                  isSpeaking ? stop() : speak();
                                },
                                child: Text(isSpeaking ? "Parar" : "Repetir"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  if (role != "idoso")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 15,
                          ),
                          child: const Text(
                            'EDITAR',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CriarTarefa(
                                    tarefa: widget.tarefa, token: widget.token),
                              ),
                            );
                          },
                        ),
                        carregandoExcluir
                            ? CircularProgressIndicator()
                            : TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  elevation: 15,
                                ),
                                child: Text(
                                  'EXCLUIR',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  Widget cancelaButton = FlatButton(
                                    child: const Text("CANCELAR"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  Widget okButton = FlatButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      setState(() {
                                        carregandoExcluir = true;
                                      });
                                      serviceTarefa.excluirTarefa(
                                          widget.tarefa['id'].toString(),
                                          widget.token,
                                          context);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Tem certeza?"),
                                        actionsAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          cancelaButton,
                                          okButton,
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: carregandoFinalizar
                            ? CircularProgressIndicator()
                            : TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size(300, 100),
                                  backgroundColor: Colors.green,
                                  elevation: 15,
                                ),
                                child: const Text(
                                  'FINALIZAR',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () async {
                                  Widget cancelaButton = FlatButton(
                                    child: const Text("CANCELAR"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  Widget okButton = FlatButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      setState(() {
                                        carregandoFinalizar = true;
                                      });
                                      serviceTarefa.finalizaTarefa(
                                          widget.tarefa['id'].toString(),
                                          widget.token,
                                          context);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Tem certeza?"),
                                        actionsAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          cancelaButton,
                                          okButton,
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
