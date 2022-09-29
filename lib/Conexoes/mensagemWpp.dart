import 'dart:convert';
import 'package:http/http.dart' as http;

class ConexaoComOWpp {
  Future<void> enviarMensagemParaOWhatsAppIdoso(String token, String id) async {
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
        "EAAHBE9UHYEgBAOZBvs769dvklG5f3YMIyhDbqtlFkHAaKaeXf0b7NUXZC1dbx7w4zZAWXKHdGlFCbaAe9ursFyifBuiJMQi55nWZBOh4mvDojAKi1sYJ5MYuV39xpX2IQ7QknpkAgWnZC9jR5UXTmi2x1BbBOeXSZADpfHTV98Q9mkyIfKqmiekZCYvKPA8vahCv1JJlX7QZBODVY5LcZA6LE";
    headers = {
      'Content-Type': 'Application/json',
      'Authorization': 'Bearer $tokenMensagem'
    };

    var mensagem = jsonEncode({
      "messaging_product": "whatsapp",
      "to": "$contato",
      "type": "template",
      "template": {
        "name": "alerta_tarefa_criada",
        "language": {"code": "pt_BR"}
      }
    });

    url =
        Uri.parse("https://graph.facebook.com/v14.0/105984795618762/messages");
    response = await http.post(url, headers: headers, body: mensagem);
    //fim do bloco
  }
}
