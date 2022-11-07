// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/components/CampoSenha.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Conexoes/ServiceResetSenha.dart';
import '../components/CampoConfirmaSenha.dart';
import '../components/CampoPreenchimento.dart';
import 'LoginPage.dart';

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

  final _formKey = GlobalKey<FormState>();

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
              child: Form(
            key: _formKey,
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
                CampoSenha(
                  controlador: _controladorCampoSenha,
                  rotulo: 'Senha',
                ),
                const SizedBox(
                  height: 10,
                ),
                CampoConfirmaSenha(
                    controlador: _controladorCampoConfSenha,
                    controladorVerificaIgualdadeSenha: _controladorCampoSenha,
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
                          var formValid =
                              _formKey.currentState?.validate() ?? false;
                          if (formValid) {
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
                              serviceResetSenha.realizaResetSenha(
                                  reset, context);
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
                          }
                        },
                      ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
