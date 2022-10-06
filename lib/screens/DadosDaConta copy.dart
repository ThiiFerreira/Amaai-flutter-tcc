import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/EdicaoDeDados.dart';

import 'package:flutter_application_1/screens/cadastro.page2.dart';
import 'package:flutter_application_1/screens/login.page.dart';

import '../models/Token.dart';

class DadosDaContaTeste extends StatefulWidget {
  var token;
  DadosDaContaTeste({Key? key, required this.token}) : super(key: key);

  @override
  State<DadosDaContaTeste> createState() => _DadosDaContaTeste();
}

class _DadosDaContaTeste extends State<DadosDaContaTeste> {
  @override
  Widget build(BuildContext context) {
    String id = ConverteToken(widget.token).ConverteTokenParaId();
    String temIdoso =
        ConverteToken(widget.token).verificaSeTemAssistidoCadastrado();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados"),
      ),
      body: ListView(
        children: [
          EditarDadosResponsavel(token: widget.token),
          EditarDadosAssistido(token: widget.token),
          CadastrarAssistido(token: widget.token, id: id),
        ],
      ),
    );
  }
}

class EditarDadosResponsavel extends StatelessWidget {
  var token;
  EditarDadosResponsavel({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle_outlined, size: 40),
            title: const Text('Editar dados responsavel'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EdicaoDeDados(token: token)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class EditarDadosAssistido extends StatelessWidget {
  var token;
  EditarDadosAssistido({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.elderly, size: 40),
            title: const Text('Editar dados assistido'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EdicaoDeDadosAssistido(token: token)),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CadastrarAssistido extends StatelessWidget {
  var token;
  var id;
  CadastrarAssistido({Key? key, required this.token, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person_add_alt, size: 40),
            title: const Text('Cadastrar assistido'),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroPage2(code: id),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
