// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Conexoes/ServiceResetSenha.dart';
import '../components/AlertaMensagem.dart';
import '../components/CampoPreenchimento.dart';
import 'RealizaResetPage.dart';

class SolitaResetSenha extends StatefulWidget {
  const SolitaResetSenha({Key? key}) : super(key: key);

  @override
  State<SolitaResetSenha> createState() => _SolitaResetSenha();
}

class _SolitaResetSenha extends State<SolitaResetSenha> {
  var serviceResetSenha = ServiceResetSenha();
  final TextEditingController controladorCampoEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    controladorCampoEmail.dispose();
    super.dispose();
  }

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuparar Senha'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CampoPreenchimentoEmail(
                    controlador: controladorCampoEmail,
                    rotulo: 'Email',
                    dica: 'example@example.com',
                    icone: Icons.email,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  carregando
                      ? const CircularProgressIndicator()
                      : TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 15,
                          ),
                          child: const Text(
                            'SOLICITAR RESET SENHA',
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
                              var reset = DadosResetSenha();
                              reset.email = controladorCampoEmail.text;
                              serviceResetSenha.solicitarResetSenha(
                                  reset, context);
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}
