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

  final loading = ValueNotifier<bool>(false);

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
              children: <Widget>[
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset("assets/Reset.png"),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  "Alterar sua senha",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                CampoPreenchimento(
                    controlador: _controladorCampoCodigoConfirmacao,
                    rotulo: "Codigo de Confirmação",
                    icone: Icons.pin),
                const SizedBox(
                  height: 10,
                ),
                CampoSenha(
                  controlador: _controladorCampoSenha,
                  rotulo: 'Nova Senha',
                ),
                const SizedBox(
                  height: 10,
                ),
                CampoConfirmaSenha(
                    controlador: _controladorCampoConfSenha,
                    controladorVerificaIgualdadeSenha: _controladorCampoSenha,
                    rotulo: 'Confirmar Nova Senha'),
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
                                    "Mudar senha",
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
                              loading.value = !loading.value;
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
