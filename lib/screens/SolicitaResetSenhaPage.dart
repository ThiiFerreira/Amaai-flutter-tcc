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
  final loading = ValueNotifier<bool>(false);
  final textAux = 'Por favor, informe o E-mail associado a sua conta '
    'que enviaremos um código para alteração de senha ! ';
  void dispose() {
    controladorCampoEmail.dispose();
    super.dispose();
  }

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuperar Senha'),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset("assets/Forgot.png"),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Esqueceu sua senha ?",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    textAux,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CampoPreenchimentoEmail(
                    controlador: controladorCampoEmail,
                    rotulo: 'Email',
                    dica: 'example@example.com',
                    icone: Icons.email,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: const [0.3, 1],
                          colors: [
                            Colors.blue[900]!,
                            Colors.blue,
                          ],
                        ),
                      ),
                      child: SizedBox.expand(
                        child: TextButton(
                          child: AnimatedBuilder(
                            animation: loading,
                            builder: (context, _) {
                              return loading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Enviar",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    );
                            },
                          ),
                          onPressed: () {
                            var formValid =
                                _formKey.currentState?.validate() ?? false;
                            if (formValid) {
                              loading.value = !loading.value;
                              var reset = DadosResetSenha();
                              reset.email = controladorCampoEmail.text;
                              serviceResetSenha.solicitarResetSenha(
                                  reset, context);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
