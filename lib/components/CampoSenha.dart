import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class CampoSenha extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  const CampoSenha({Key? key, required this.controlador, required this.rotulo})
      : super(key: key);

  @override
  State<CampoSenha> createState() => _CampoSenhaState();
}

class _CampoSenhaState extends State<CampoSenha> {
  bool _mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(1.0),
        labelText: widget.rotulo,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
              _mostrarSenha == false ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _mostrarSenha = !_mostrarSenha;
            });
          },
        ),
        //hintText: "*******",
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      obscureText: _mostrarSenha == false ? true : false,
      style: const TextStyle(fontSize: 20),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final verificaCaracterEspecial = RegExp(r"[@!#$%^&*()/\\]");
        final verificarLetraMaiucula = RegExp(r"[A-Z]");
        final verificarLetraMiniscula = RegExp(r"[A-Z]");
        final verificarNumero = RegExp(r"[0-9]");
        if (value.toString().isEmpty) {
          return "Campo requerido";
        }
        if (value.toString().length < 6) {
          return "Senha deve ter no minimo 6 digitos";
        }
        if (!verificaCaracterEspecial.hasMatch(value!)) {
          return "A senha deve conter pelo menos um caracter especial !";
        }
        if (!verificarLetraMaiucula.hasMatch(value)) {
          return "A senha deve conter pelo menos uma letra maiuscula !";
        }
        if (!verificarLetraMiniscula.hasMatch(value)) {
          return "A senha deve conter pelo menos uma letra minuscula !";
        }
        if (!verificarNumero.hasMatch(value!)) {
          return "A senha deve conter pelo menos um numero !";
        }
        return null;
      },
    );
  }
}

class CampoSenhaSemAutoValidacao extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  const CampoSenhaSemAutoValidacao(
      {Key? key, required this.controlador, required this.rotulo})
      : super(key: key);

  @override
  State<CampoSenhaSemAutoValidacao> createState() =>
      _CampoSenhaSemAutoValidacaoState();
}

class _CampoSenhaSemAutoValidacaoState
    extends State<CampoSenhaSemAutoValidacao> {
  bool _mostrarSenha = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controlador,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(1.0),
        labelText: widget.rotulo,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
              _mostrarSenha == false ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _mostrarSenha = !_mostrarSenha;
            });
          },
        ),
        //hintText: "*******",
        labelStyle: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      obscureText: _mostrarSenha == false ? true : false,
      style: const TextStyle(fontSize: 20),
      validator: Validatorless.multiple(
        [
          Validatorless.required("Campo requerido"),
        ],
      ),
    );
  }
}
