import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/TarefasExcluidasPage.dart';
import 'package:flutter_application_1/screens/TarefasFinalizadasPage.dart';
import 'HomePage.dart';

class HistoricoTarefas extends StatefulWidget {
  var token;
  HistoricoTarefas({Key? key, required this.token}) : super(key: key);

  @override
  State<HistoricoTarefas> createState() => _HistoricoTarefasState();
}

class _HistoricoTarefasState extends State<HistoricoTarefas> {
  @override
  Widget build(BuildContext context) {
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                //simbolos das tabs
                Tab(icon: Icon(Icons.task)),
                Tab(icon: Icon(Icons.delete)),
              ],
            ),
            title: const Text('Historico de tarefas'),
          ),
          body: TabBarView(
            //conteudo de cada tab
            children: [
              TarefaFinalizadas(
                token: widget.token,
              ),
              TarefasExcluidas(
                token: widget.token,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
