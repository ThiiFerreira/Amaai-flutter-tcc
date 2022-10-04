// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../Conexoes/ServiceCadastroResponsavel.dart';
import '../components/CampoCEP.dart';
import '../components/CampoData.dart';
import '../components/CampoPreenchimento.dart';
import '../components/CamposSenha.dart';
import '../components/LogoETitulo.dart';
import '../models/CadastroUsuario.dart';

// ignore: must_be_immutable
class CadastroPage1 extends StatefulWidget {
  const CadastroPage1({Key? key}) : super(key: key);

  @override
  State<CadastroPage1> createState() => _CadastroPage1();
}

class _CadastroPage1 extends State<CadastroPage1> {
  var serviceCadastro = ServiceCadastroResponsavel();
  final _formKey = GlobalKey<FormState>();

  final _controladorCampoNome = TextEditingController();
  final _controladorCampoUsername = TextEditingController();
  final _controladorCampoCpf = TextEditingController();
  final _controladorCampoDataNasc = TextEditingController();
  final _controladorCampoTelefone = TextEditingController();
  final _controladorCampoEmail = TextEditingController();
  final _controladorCampoEndereco = TextEditingController();
  final _controladorCampoSenha = TextEditingController();
  final _controladorCampoConfSenha = TextEditingController();
  final _controladorCampoCEP = TextEditingController();
  final loading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _controladorCampoNome.dispose();
    _controladorCampoUsername.dispose();
    _controladorCampoCpf.dispose();
    _controladorCampoDataNasc.dispose();
    _controladorCampoTelefone.dispose();
    _controladorCampoEmail.dispose();
    _controladorCampoEndereco.dispose();
    _controladorCampoSenha.dispose();
    _controladorCampoConfSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            LogoTitulo(titulo: 'Responsavel'),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  CampoPreenchimento(
                      controlador: _controladorCampoNome,
                      rotulo: 'Nome Completo',
                      icone: Icons.person),
                  const SizedBox(
                    height: 10,
                  ),
                  CampoPreenchimento(
                      controlador: _controladorCampoUsername,
                      rotulo: 'Username',
                      icone: Icons.account_circle_outlined),
                  const SizedBox(
                    height: 10,
                  ),
                  CampoPreenchimento(
                      controlador: _controladorCampoCpf,
                      rotulo: 'CPF',
                      teclado: TextInputType.number,
                      icone: Icons.pin),
                  const SizedBox(
                    height: 10,
                  ),
                  CampoData(
                    controlador: _controladorCampoDataNasc,
                    rotulo: "Data de Nascimento",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CampoPreenchimento(
                      controlador: _controladorCampoTelefone,
                      rotulo: 'Telefone (fixo ou celular)',
                      dica: '11 99999-9999',
                      teclado: TextInputType.phone,
                      icone: Icons.phone),
                  const SizedBox(
                    height: 10,
                  ),
                  CampoPreenchimento(
                      controlador: _controladorCampoEmail,
                      rotulo: 'Email',
                      dica: 'name@example.com',
                      teclado: TextInputType.emailAddress,
                      icone: Icons.email),
                  const SizedBox(
                    height: 10,
                  ),
                  CampoCEP(
                      controladorCEP: _controladorCampoCEP,
                      controladorEnderecoCompleto: _controladorCampoEndereco,
                      icone: Icons.home),
                  const SizedBox(
                    height: 15,
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
                    height: 20,
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
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
                                "Cadastrar Dados",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              );
                      }),
                  onPressed: () {
                    var formValid = _formKey.currentState?.validate() ?? false;
                    if (formValid) {
                      var cadastro = CadastroUsuario(
                          _controladorCampoNome.text,
                          _controladorCampoUsername.text,
                          _controladorCampoCpf.text,
                          _controladorCampoDataNasc.text,
                          _controladorCampoTelefone.text,
                          _controladorCampoEndereco.text,
                          _controladorCampoSenha.text,
                          _controladorCampoConfSenha.text);
                      cadastro.Email = _controladorCampoEmail.text;
                      serviceCadastro.criaCadastro(cadastro, context);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
