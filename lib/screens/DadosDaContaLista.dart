import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/EdicaoDeDados.dart';

import 'package:flutter_application_1/screens/cadastro.page2.dart';

import '../models/Token.dart';

class DadosDaContaLista extends StatefulWidget {
  var token;
  DadosDaContaLista({Key? key, required this.token}) : super(key: key);

  @override
  State<DadosDaContaLista> createState() => _DadosDaContaLista();
}

class _DadosDaContaLista extends State<DadosDaContaLista> {
  bool lista = true;
  IconData icone = Icons.grid_4x4;

  @override
  Widget build(BuildContext context) {
    String id = ConverteToken(widget.token).ConverteTokenParaId();
    String temIdoso =
        ConverteToken(widget.token).verificaSeTemAssistidoCadastrado();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados"),
        actions: <Widget>[
          IconButton(
            icon: Icon(icone),
            onPressed: () {
              setState(() {
                lista = !lista;
                !lista ? icone = Icons.list : icone = Icons.grid_on;
              });
            },
          )
        ],
      ),
      body: lista == true
          ? ListView(
              children: [
                EditarDadosResponsavel(token: widget.token),
                if (temIdoso != "0") EditarDadosAssistido(token: widget.token),
                if (temIdoso == "0")
                  CadastrarAssistido(token: widget.token, id: id),
              ],
            )
          : Column(
              // inicio do codigo para deixar grade
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 180,
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
                                      EdicaoDeDados(token: widget.token)),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.account_circle_outlined,
                                size: 80,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Editar dados responsavel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (temIdoso != "0")
                        Container(
                          height: 180,
                          width: 150,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
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
                                        EdicaoDeDadosAssistido(
                                            token: widget.token)),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.elderly,
                                  size: 80,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Editar dados assistido',
                                  textAlign: TextAlign.center,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (temIdoso == "0")
                        Container(
                          height: 170,
                          width: 150,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
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
                              bool criou = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CadastroPage2(code: id),
                                ),
                              );
                              if (criou) {
                                setState(() {
                                  temIdoso = "1";
                                });
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.person_add_alt,
                                  size: 80,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Cadastrar assistido',
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
                )
              ],
            ), // fim do codigo para deixar grade
    );
  }
}

class EditarDadosResponsavel extends StatelessWidget {
  var token;
  EditarDadosResponsavel({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(1),
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
      margin: EdgeInsets.all(1),
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
      margin: EdgeInsets.all(1),
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
