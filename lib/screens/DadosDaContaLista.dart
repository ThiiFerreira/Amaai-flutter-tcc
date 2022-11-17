import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/EdicaoDeDadosPage.dart';
import 'package:flutter_application_1/screens/CadastroAssistidoPage.dart';
import '../models/Token.dart';
import 'package:http/http.dart' as http;

class DadosDaContaLista extends StatefulWidget {
  var token;
  bool? temAssistido;
  DadosDaContaLista({Key? key, required this.token, this.temAssistido})
      : super(key: key);

  @override
  State<DadosDaContaLista> createState() => _DadosDaContaLista();
}

class _DadosDaContaLista extends State<DadosDaContaLista> {
  var temAssistido = null;

  Future<void> fazRequisicaoRecuperaSeTemAssistidoCadastrado(
      String token) async {
    var headers = {'Authorization': 'Bearer $token'};
    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/dados/responsavel/assistido");
    var response = await http.get(url, headers: headers);
    if (response.body == "true") {
      setState(() {
        temAssistido = true;
      });
    } else {
      setState(() {
        temAssistido = false;
      });
    }
  }

  @override
  void initState() {
    fazRequisicaoRecuperaSeTemAssistidoCadastrado(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    String id = ConverteToken(widget.token).ConverteTokenParaId();
    fazRequisicaoRecuperaSeTemAssistidoCadastrado(widget.token);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados"),
      ),
      body: ListView(
        children: [
          EditarDadosResponsavel(token: widget.token),
          widget.temAssistido == false
              ? CadastrarAssistido(token: widget.token, id: id)
              : EditarDadosAssistido(token: widget.token),
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
      margin: const EdgeInsets.all(1),
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
      margin: const EdgeInsets.all(1),
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
      margin: const EdgeInsets.all(1),
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
                  builder: (context) =>
                      CadastroPage2(idResponsavel: id, token: token),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
