import 'package:flutter/material.dart';

class CampoConfirmaSenha extends StatefulWidget {
  final TextEditingController controladorVerificaIgualdadeSenha;
  final TextEditingController controlador;
  final String rotulo;
  const CampoConfirmaSenha(
      {Key? key,
      required this.controlador,
      required this.rotulo,
      required this.controladorVerificaIgualdadeSenha})
      : super(key: key);

  @override
  State<CampoConfirmaSenha> createState() => _CampoConfirmaSenhaState();
}

class _CampoConfirmaSenhaState extends State<CampoConfirmaSenha> {
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
      validator: (value) {
        if (value.toString().isEmpty) {
          return "Campo requerido";
        }
        if (widget.controladorVerificaIgualdadeSenha.text != value.toString()) {
          return "A senha deve ser igual a definida no campo acima";
        }
        return null;
      },
    );
  }
}
