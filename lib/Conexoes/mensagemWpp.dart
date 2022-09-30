import 'dart:convert';
import 'package:http/http.dart' as http;

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
        "EAAHBE9UHYEgBAAiZBAY51y4k8o6gjdA9KiNJJkzJC37vwKkndne4KozUm8Sh8nUn3wVqysrF9RTdlYEGvyaSjuvBpH2zZA9esb2zggaoX2d0GtXZBjwSxr2sU50nve6fCm4zQxCk0gTw90GBNokdWCqa0OWsf6hHaJZBiAg9xiV17uocxeGyZC83BYon5SFQWGyKZAPpy3LqIQ6PJvDgnZA";
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
        Uri.parse("https://graph.facebook.com/v13.0/105984795618762/messages");
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
