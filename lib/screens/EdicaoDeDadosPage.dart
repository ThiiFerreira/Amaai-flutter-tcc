import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AlertaMensagem.dart';
import 'package:flutter_application_1/components/CampoCEP.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Conexoes/ServiceConta.dart';
import '../Conexoes/ServiceEdicaoDados.dart';
import '../components/CampoData.dart';
import '../components/CampoPreenchimento.dart';
import '../models/DadosCadastraisAtualizados.dart';
import '../models/Token.dart';

class EdicaoDeDados extends StatefulWidget {
  var token;
  EdicaoDeDados({Key? key, required this.token}) : super(key: key);

  @override
  State<EdicaoDeDados> createState() => _EdicaoDeDadosState();
}

class _EdicaoDeDadosState extends State<EdicaoDeDados> {
  var serviceAtualizarDados = ServiceEdicaoDados();
  var serviceConta = ServiceConta();

  void recuperaDadosResponsavelEConverte(String token) async {
    var response = await serviceAtualizarDados.recuperaDadosResponsavel(token);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      controladorCampoNome.text = json['nome'].toString();
      controladorCampoUsername.text = json['username'].toString();
      controladorCampoCpf.text = json['cpf'].toString();
      controladorCampoDataNasc.text = json['dataNascimento'].toString();
      controladorCampoTelefone.text = json['telefone'].toString();
      controladorCampoEmail.text = json['email'].toString();
      controladorCampoEndereco.text = json['endereco'].toString();
    } else {
      String mensagem = "Falha ao carregar dados";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  void atualizaDadosResponsavel(DadosAtualizados dados, String token) async {
    var response = await serviceAtualizarDados.realizaUpdateDeDadosResponsavel(
        dados, token);
    String mensagem;
    if (response.statusCode == 204) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 2));
      limpaControles();
      setState(() {
        Navigator.pop(context);
        recuperaDadosResponsavelEConverte(token);
      });
      var snackBar = const SnackBar(
        content: Text('Dados atualizados com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      mensagem = "Falha ao atualizar dados";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  void limpaControles() {
    controladorCampoNome.text = "";
    controladorCampoUsername.text = "";
    controladorCampoCpf.text = "";
    controladorCampoDataNasc.text = "";
    controladorCampoTelefone.text = "";
    controladorCampoEmail.text = "";
    controladorCampoEndereco.text = "";
    controladorCampoEndereco.text = "";
  }

  final controladorCampoNome = TextEditingController();
  final controladorCampoUsername = TextEditingController();
  final controladorCampoCpf = TextEditingController();
  final controladorCampoDataNasc = TextEditingController();
  final controladorCampoTelefone = TextEditingController();
  final controladorCampoEmail = TextEditingController();
  final controladorCampoEndereco = TextEditingController();
  final controladorCampoCEP = TextEditingController();
  bool bloqueado = true;
  IconData icone = Icons.edit;

  String id = '';
  @override
  Widget build(BuildContext context) {
    id = ConverteToken(widget.token).ConverteTokenParaId();
    recuperaDadosResponsavelEConverte(widget.token);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edição de dados responsavel"),
          actions: <Widget>[
            IconButton(
              icon: Icon(icone),
              onPressed: () {
                setState(() {
                  if (bloqueado == true) {
                    bloqueado = false;
                    icone = Icons.edit_off_outlined;
                  } else {
                    bloqueado = true;
                    icone = Icons.edit;
                  }
                });
              },
            )
          ],
        ),
        body: Form(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    CampoPreenchimento(
                      controlador: controladorCampoNome,
                      rotulo: 'Nome Completo',
                      icone: Icons.person,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoUsername,
                      rotulo: 'Username',
                      icone: Icons.account_circle_outlined,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoCpf,
                      rotulo: 'CPF',
                      teclado: TextInputType.number,
                      icone: Icons.pin,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoData(
                      controlador: controladorCampoDataNasc,
                      rotulo: "Data de Nascimento",
                      naoMostrar: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoTelefone,
                      rotulo: 'Telefone (fixo ou celular)',
                      dica: '11 99999-9999',
                      teclado: TextInputType.phone,
                      icone: Icons.phone,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoEmail,
                      rotulo: 'Email',
                      dica: 'name@example.com',
                      teclado: TextInputType.emailAddress,
                      icone: Icons.email,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (bloqueado == true)
                      CampoPreenchimento(
                        controlador: controladorCampoEndereco,
                        rotulo: 'Endereco',
                        teclado: TextInputType.name,
                        icone: Icons.home,
                        enable: bloqueado,
                      ),
                    if (bloqueado == false)
                      CampoCEP(
                        controladorCEP: controladorCampoCEP,
                        controladorEnderecoCompleto: controladorCampoEndereco,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (bloqueado == false)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            bloqueado = true;
                            icone = Icons.edit;
                          });
                          var dados = DadosAtualizados(
                              controladorCampoNome.text,
                              controladorCampoUsername.text,
                              controladorCampoCpf.text,
                              controladorCampoDataNasc.text,
                              controladorCampoTelefone.text,
                              controladorCampoEmail.text,
                              controladorCampoEndereco.text);
                          atualizaDadosResponsavel(dados, widget.token);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          primary: Colors.white,
                        ),
                        child: const Text("Finalizar edição"),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            primary: Colors.red,
                          ),
                          child: const Text('Excluir conta'),
                          onPressed: () {
                            TextEditingController controlador =
                                TextEditingController();

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Digite sua senha para validar:"),
                                    content: Form(
                                        child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CampoPreenchimento(
                                            controlador: controlador,
                                            rotulo: "Senha")
                                      ],
                                    )),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          serviceConta.excluirContaResponsavel(
                                              controlador.text,
                                              widget.token,
                                              context);
                                        },
                                        child: const Text('Confirmar'),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ));
  }
}

class EdicaoDeDadosAssistido extends StatefulWidget {
  var token;
  EdicaoDeDadosAssistido({Key? key, required this.token}) : super(key: key);

  @override
  State<EdicaoDeDadosAssistido> createState() => _EdicaoDeDadosAssistidoState();
}

class _EdicaoDeDadosAssistidoState extends State<EdicaoDeDadosAssistido> {
  var serviceAtualizarDados = ServiceEdicaoDados();
  var serviceConta = ServiceConta();

  void recuperaDadosAssistidoEConverte(String token) async {
    var response = await serviceAtualizarDados.recuperaDadosAssistido(token);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      controladorCampoNome.text = json['nome'].toString();
      controladorCampoUsername.text = json['username'].toString();
      controladorCampoCpf.text = json['cpf'].toString();
      controladorCampoDataNasc.text = json['dataNascimento'].toString();
      controladorCampoTelefone.text = json['telefone'].toString();
      controladorCampoEndereco.text = json['endereco'].toString();
    } else {
      String mensagem = "Falha ao carregar dados";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  void atualizaDadosAssistido(DadosAtualizados dados, String token) async {
    var response =
        await serviceAtualizarDados.realizaUpdateDeDadosAssistido(dados, token);
    String mensagem;
    if (response.statusCode == 204) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(const Duration(seconds: 2));
      limpaControles();
      setState(() {
        Navigator.pop(context);
        recuperaDadosAssistidoEConverte(widget.token);
      });
      var snackBar = const SnackBar(
        content: Text('Dados atualizados com sucesso!'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      mensagem = "Falha ao atualizar dados";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertaMensagem(mensagem: mensagem);
        },
      );
    }
  }

  void limpaControles() {
    controladorCampoNome.text = "";
    controladorCampoUsername.text = "";
    controladorCampoCpf.text = "";
    controladorCampoDataNasc.text = "";
    controladorCampoTelefone.text = "";
    controladorCampoEndereco.text = "";
    controladorCampoEndereco.text = "";
  }

  final controladorCampoNome = TextEditingController();
  final controladorCampoUsername = TextEditingController();
  final controladorCampoCpf = TextEditingController();
  final controladorCampoDataNasc = TextEditingController();
  final controladorCampoTelefone = TextEditingController();
  final controladorCampoEndereco = TextEditingController();
  final controladorCampoCEP = TextEditingController();
  bool bloqueado = true;
  IconData icone = Icons.edit;

  @override
  Widget build(BuildContext context) {
    recuperaDadosAssistidoEConverte(widget.token);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edição de dados Assistido"),
          actions: <Widget>[
            IconButton(
              icon: Icon(icone),
              onPressed: () {
                setState(() {
                  if (bloqueado == true) {
                    bloqueado = false;
                    icone = Icons.edit_off_outlined;
                  } else {
                    bloqueado = true;
                    icone = Icons.edit;
                  }
                });
              },
            )
          ],
        ),
        body: Form(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    CampoPreenchimento(
                      controlador: controladorCampoNome,
                      rotulo: 'Nome Completo',
                      icone: Icons.person,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoUsername,
                      rotulo: 'Username',
                      icone: Icons.account_circle_outlined,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoCpf,
                      rotulo: 'CPF',
                      teclado: TextInputType.number,
                      icone: Icons.pin,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoData(
                      controlador: controladorCampoDataNasc,
                      rotulo: "Data de Nascimento",
                      naoMostrar: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CampoPreenchimento(
                      controlador: controladorCampoTelefone,
                      rotulo: 'Telefone (fixo ou celular)',
                      dica: '11 99999-9999',
                      teclado: TextInputType.phone,
                      icone: Icons.phone,
                      enable: bloqueado,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (bloqueado == true)
                      CampoPreenchimento(
                        controlador: controladorCampoEndereco,
                        rotulo: 'Endereco',
                        teclado: TextInputType.name,
                        icone: Icons.home,
                        enable: bloqueado,
                      ),
                    if (bloqueado == false)
                      CampoCEP(
                        controladorCEP: controladorCampoCEP,
                        controladorEnderecoCompleto: controladorCampoEndereco,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (bloqueado == false)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            bloqueado = true;
                            icone = Icons.edit;
                          });
                          var dados = DadosAtualizados(
                              controladorCampoNome.text,
                              controladorCampoUsername.text,
                              controladorCampoCpf.text,
                              controladorCampoDataNasc.text,
                              controladorCampoTelefone.text,
                              null,
                              controladorCampoEndereco.text);
                          atualizaDadosAssistido(dados, widget.token);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          primary: Colors.white,
                        ),
                        child: const Text("Finalizar edição"),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            primary: Colors.red,
                          ),
                          child: const Text('Excluir conta'),
                          onPressed: () {
                            TextEditingController controlador =
                                TextEditingController();

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        "Digite sua senha para validar:"),
                                    content: Form(
                                        child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CampoPreenchimento(
                                            controlador: controlador,
                                            rotulo: "Senha")
                                      ],
                                    )),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          serviceConta.excluirContaAssistido(
                                              controlador.text,
                                              widget.token,
                                              context);
                                        },
                                        child: const Text('Confirmar'),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ));
  }
}
