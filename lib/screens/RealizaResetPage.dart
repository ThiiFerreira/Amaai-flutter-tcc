// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/components/CamposSenha.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Conexoes/ServiceResetSenha.dart';
import '../components/CampoPreenchimento.dart';
import 'login.page.dart';

class RealizaReset extends StatefulWidget {
  String token;
  int codigoVerificacao;
  String email;
  RealizaReset(
      {Key? key,
      required this.token,
      required this.codigoVerificacao,
      required this.email})
      : super(key: key);

  @override
  State<RealizaReset> createState() => _RealizaResetState();
}

class _RealizaResetState extends State<RealizaReset> {
  var serviceResetSenha = ServiceResetSenha();

  final _controladorCampoSenha = TextEditingController();

  final _controladorCampoConfSenha = TextEditingController();

  final _controladorCampoCodigoConfirmacao = TextEditingController();

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confirmar nova senha'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CampoPreenchimento(
                  controlador: _controladorCampoCodigoConfirmacao,
                  rotulo: "Codigo de Confirmação",
                  icone: Icons.pin),
              const SizedBox(
                height: 10,
              ),
              CamposSenha(
                controlador: _controladorCampoSenha,
                rotulo: 'Senha',
              ),
              const SizedBox(
                height: 10,
              ),
              CamposSenha(
                  controlador: _controladorCampoConfSenha,
                  rotulo: 'Confirmar Senha'),
              const SizedBox(
                height: 10,
              ),
              carregando
                  ? CircularProgressIndicator()
                  : TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 15,
                      ),
                      child: const Text(
                        'CONFIRMAR RESET SENHA',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          carregando = true;
                        });
                        var reset = camposReset(
                            widget.email,
                            _controladorCampoSenha.text,
                            _controladorCampoConfSenha.text,
                            widget.token);
                        if (widget.codigoVerificacao.toString() ==
                            _controladorCampoCodigoConfirmacao.text) {
                          serviceResetSenha.realizaResetSenha(reset, context);
                        } else {
                          var mensagem = "Falha ao redefinir senha";
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertaMensagem(mensagem: mensagem);
                            },
                          );
                          setState(() {
                            carregando = false;
                          });
                        }
                      },
                    ),
            ],
          )),
        ),
      ),
    );
  }
}
