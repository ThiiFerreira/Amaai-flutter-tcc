import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/EdicaoDeDados.dart';

import 'package:flutter_application_1/screens/cadastro.page2.dart';
import 'package:flutter_application_1/screens/login.page.dart';

import '../models/Token.dart';

class DadosDaConta extends StatefulWidget {
  var token;
  DadosDaConta({Key? key, required this.token}) : super(key: key);

  @override
  State<DadosDaConta> createState() => _DadosDaConta();
}

class _DadosDaConta extends State<DadosDaConta> {
  @override
  Widget build(BuildContext context) {
    String id = ConverteToken(widget.token).ConverteTokenParaId();
    String temIdoso =
        ConverteToken(widget.token).verificaSeTemAssistidoCadastrado();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dados"),
      ),
      body: Column(
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
                                EdicaoDeDadosAssistido(token: widget.token)),
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
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastroPage2(code: id),
                          ),
                        );
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
      ),
    );
  }
}
