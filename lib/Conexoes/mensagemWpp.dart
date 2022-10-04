import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Tarefa.dart';

class ConexaoComOWpp {
  Future<void> enviarMensagemParaOWhatsAppIdoso(
      String token, String id, String? hora, String? data) async {
    //inicio do bloco para recuperar contato do idoso
    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/RecuperaEAtualizaDados/assistido/$id/contato");
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(url, headers: headers);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    var contato = "55" + json.toString();
    //fim do bloco

    //inicio do bloco para enviar a mensagem para o idoso
    var tokenMensagem =
        "EAAHBE9UHYEgBAKZAi9JOPKJIHGelWjZCWNgO974AkIm6SWBMUH68ZC96KD20lBqZC3cZBsCRrMjI2X5cyV9deYJMNmZCzjy54XZAyPvGyCKRHm1Y4WzOHK8coojowkY105GXYfn8QODJ1eFtZCDPxAmLPr1lMjgI4JZBD6ouZC2JoAFGq5D8beyiRZCLdSK3L3W3ttBFqbxFtxWBwZDZD";
    headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $tokenMensagem'
    };

    var mensagemTemplate = jsonEncode({
      "messaging_product": "whatsapp",
      "to": "$contato",
      "type": "template",
      "template": {
        "name": "alerta_tarefa_criada",
        "language": {"code": "pt_BR"}
      }
    });

    var mensagemTemplatePersonalizada = jsonEncode({
      "messaging_product": "whatsapp",
      "to": "$contato",
      "type": "template",
      "template": {
        "name": "alerta_tarefa_criada_personalizada",
        "language": {"code": "pt_BR"},
        "components": [
          {
            "type": "body",
            "parameters": [
              {"type": "text", "text": "$hora"},
              {"type": "text", "text": "$data"}
            ]
          }
        ]
      }
    });

    url =
        Uri.parse("https://graph.facebook.com/v14.0/105984795618762/messages");
    response = await http.post(url,
        headers: headers, body: mensagemTemplatePersonalizada);
    if (response.statusCode == 200) {
      print("Mensagem enviada");
    } else {
      print("erro ao enviar mensagem");
      print(response.body);
    }
    //fim do bloco
  }

  Future<void> enviarMensagemParaOWhatsAppIdosoRealizarTarefa(
      String token, String id, Tarefa tarefa) async {
    //inicio do bloco para recuperar contato do idoso
    var url = Uri.parse(
        "https://app-tcc-amai-producao.herokuapp.com/RecuperaEAtualizaDados/assistido/$id/contato");
    var headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $token'
    };
    var response = await http.get(url, headers: headers);

    var json = jsonDecode(utf8.decode(response.bodyBytes));

    var contato = "55" + json.toString();
    //fim do bloco

    //inicio do bloco para enviar a mensagem para o idoso
    var tokenMensagem =
        "EAAHBE9UHYEgBAKZAi9JOPKJIHGelWjZCWNgO974AkIm6SWBMUH68ZC96KD20lBqZC3cZBsCRrMjI2X5cyV9deYJMNmZCzjy54XZAyPvGyCKRHm1Y4WzOHK8coojowkY105GXYfn8QODJ1eFtZCDPxAmLPr1lMjgI4JZBD6ouZC2JoAFGq5D8beyiRZCLdSK3L3W3ttBFqbxFtxWBwZDZD";
    headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $tokenMensagem'
    };

    var mensagemTemplatePersonalizada = jsonEncode({
      "messaging_product": "whatsapp",
      "to": "$contato",
      "type": "template",
      "template": {
        "name": "alerta_notificacao_realaizar_tarefa",
        "language": {"code": "pt_BR"},
        "components": [
          {
            "type": "body",
            "parameters": [
              {"type": "text", "text": tarefa.titulo},
            ]
          }
        ]
      }
    });

    url =
        Uri.parse("https://graph.facebook.com/v14.0/105984795618762/messages");
    response = await http.post(url,
        headers: headers, body: mensagemTemplatePersonalizada);
    if (response.statusCode == 200) {
      print("Mensagem enviada");
    } else {
      print("erro ao enviar mensagem");
      print(response.body);
    }
    //fim do bloco
  }
}
