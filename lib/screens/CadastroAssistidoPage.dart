// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CampoCEP.dart';
import '../Conexoes/ServiceCadastroAssistido.dart';
import '../components/CampoConfirmaSenha.dart';
import '../components/CampoData.dart';
import '../components/CampoPreenchimento.dart';
import '../components/CampoSenha.dart';
import '../components/LogoETitulo.dart';
import '../models/CadastroUsuario.dart';

// ignore: must_be_immutable
class CadastroPage2 extends StatefulWidget {
  String code;
  CadastroPage2({Key? key, required this.code}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CadastroPage2> createState() => _CadastroPage2(code);
}

class _CadastroPage2 extends State<CadastroPage2> {
  var serviceCadastro = ServiceCadastroAssistido();
  String code;

  _CadastroPage2(this.code);

  final _formKey = GlobalKey<FormState>();
  final loading = ValueNotifier<bool>(false);

  final _controladorCampoNome = TextEditingController();
  final _controladorCampoUsername = TextEditingController();
  final _controladorCampoCpf = TextEditingController();
  final _controladorCampoDataNasc = TextEditingController();
  final _controladorCampoTelefone = TextEditingController();
  final _controladorCampoCEP = TextEditingController();
  final _controladorCampoEndereco = TextEditingController();
  final _controladorCampoSenha = TextEditingController();
  final _controladorCampoConfSenha = TextEditingController();

  @override
  void dispose() {
    _controladorCampoNome.dispose();
    _controladorCampoUsername.dispose();
    _controladorCampoCpf.dispose();
    _controladorCampoDataNasc.dispose();
    _controladorCampoTelefone.dispose();
    _controladorCampoCEP.dispose();
    _controladorCampoSenha.dispose();
    _controladorCampoConfSenha.dispose();
    super.dispose();
  }

  int _extraiResponsavelId(String code) {
    int id = 0;
    int inicio = code.length - 5;
    var result = code.substring(inicio);
    id = int.tryParse(result.toString())!;
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pessoa Assistida"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            LogoTitulo(titulo: "Pessoa Assistida"),
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
                  CampoCEP(
                      controladorCEP: _controladorCampoCEP,
                      controladorEnderecoCompleto: _controladorCampoEndereco,
                      rotulo: 'Endereço',
                      dica: 'Rua Exemplo, 999 - Exemplo - 99999-999',
                      icone: Icons.home),
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
                    height: 40,
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
                          },
                        ),
                        onPressed: () {
                          var formValid =
                              _formKey.currentState?.validate() ?? false;
                          if (formValid) {
                            var responsavelId = _extraiResponsavelId(code);
                            var cadastro = CadastroUsuario(
                                _controladorCampoNome.text,
                                _controladorCampoUsername.text,
                                _controladorCampoCpf.text,
                                _controladorCampoDataNasc.text,
                                _controladorCampoTelefone.text,
                                _controladorCampoEndereco.text,
                                _controladorCampoSenha.text,
                                _controladorCampoConfSenha.text);
                            cadastro.ResponsavelId = responsavelId;
                            serviceCadastro.criaCadastro(cadastro, context);
                            loading.value = !loading.value;
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
          ],
        ),
      ),
    );
  }
}
