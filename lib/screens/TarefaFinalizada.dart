// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../Conexoes/ServiceTarefas.dart';
import '../models/Token.dart';

// ignore: must_be_immutable
class TarefaFinalizada extends StatefulWidget {
  Map<String, dynamic> tarefa;
  var token;
  TarefaFinalizada({Key? key, required this.tarefa, this.token})
      : super(key: key);

  @override
  State<TarefaFinalizada> createState() => _TarefaFinalizadaState();
}

class _TarefaFinalizadaState extends State<TarefaFinalizada> {
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

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    String role = ConverteToken(widget.token).ConverteTokenParaRole();

    return Scaffold(
      appBar: AppBar(title: Text('Finalizada')),
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
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                widget.tarefa['titulo'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Divider(),
                              Text(
                                'Criada: ' + widget.tarefa['dataCriacao'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Divider(),
                              Text(
                                'Finalizada: ' +
                                    widget.tarefa['dataFinalizacao'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Divider(),
                              Text(
                                'Data do alerta: ' +
                                    widget.tarefa['dataAlerta'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
                              ),
                              Divider(),
                              Text(
                                'Horario do alerta: ' +
                                    widget.tarefa['horaAlerta'],
                                style: TextStyle(fontSize: 30),
                                textAlign: TextAlign.center,
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
                        carregando
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
                                        carregando = true;
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
