import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/HistoricoTarefasPage.dart';
import 'package:flutter_application_1/screens/LoginPage.dart';
import 'package:flutter_application_1/screens/TarefasPage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../Conexoes/ServiceConta.dart';
import '../models/Token.dart';
import 'DadosDaContaLista.dart';

class HomePage extends StatefulWidget {
  var token;
  HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSpeaking = false;
  final _flutterTts = FlutterTts();

  Future<bool?> confirmacaoSairDoApp() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Deseja sair do AMAAI?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => exit(0),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

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

  void speak(String itemHome) async {
    await _flutterTts.speak(itemHome);
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

  @override
  Widget build(BuildContext context) {
    String id = ConverteToken(widget.token).ConverteTokenParaId();
    String role = ConverteToken(widget.token).ConverteTokenParaRole();

    return WillPopScope(
      onWillPop: () async {
        final confirmacao = await confirmacaoSairDoApp();
        return confirmacao ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          leading: const Icon(Icons.home),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 170,
                      width: 150,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.fromBorderSide(
                          BorderSide(
                            width: 4,
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ), //BorderSide
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TarefasPage(token: widget.token)),
                          );
                        },
                        onLongPress: () {
                          speak("Tarefas agendadas");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.calendar_today,
                              size: 80,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Tarefas Agendadas',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 170,
                      width: 150,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.fromBorderSide(
                          BorderSide(
                            width: 4,
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ), //BorderSide
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HistoricoTarefas(token: widget.token)),
                          );
                        },
                        onLongPress: () {
                          speak("Hist??rico de tarefas");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.task_alt_outlined,
                              size: 80,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Hist??rico de Tarefas',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (role != "idoso")
                      Container(
                        height: 170,
                        width: 150,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.fromBorderSide(
                            BorderSide(
                              width: 4,
                              color: Colors.black,
                              style: BorderStyle.solid,
                            ), //BorderSide
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                          onPressed: () async {
                            var temAssistido = await ServiceConta()
                                .fazRequisicaoRecuperaSeTemAssistidoCadastrado(
                                    widget.token);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DadosDaContaLista(
                                  token: widget.token,
                                  temAssistido: temAssistido,
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            speak("Dados da conta");
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.settings,
                                size: 80,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Dados da conta',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Container(
                      height: 170,
                      width: 150,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.fromBorderSide(
                          BorderSide(
                            width: 4,
                            color: Colors.black,
                            style: BorderStyle.solid,
                          ), //BorderSide
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        onPressed: () {
                          _deslogarDaConta();
                        },
                        onLongPress: () {
                          speak("Sair");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.exit_to_app,
                              size: 80,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Sair',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _deslogarDaConta() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deseja deslogar do AMAAI?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Sim'),
              ),
            ],
          );
        });
  }
}
