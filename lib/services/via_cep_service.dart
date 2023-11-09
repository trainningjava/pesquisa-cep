import 'package:http/http.dart' as http;
import 'package:pesquisa_cep/models/result_cep.dart';

class ViaCepService {
  static Future<ResultCep> fetchCep({required String cep}) async {
    String uri = 'https://viacep.com.br/ws/$cep/json/';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      return ResultCep.fromJson(response.body);
    } else {
      throw Exception('Requisição inválida!');
    }
  }
}
