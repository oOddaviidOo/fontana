import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:Fontana/src/models/fuente.dart';

class Fuentes_Provider {
  final String _url = "https://fontana-dhc0001.firebaseio.com/";
  Future<bool> crearFuente(Fuente fuente) async {
    final url = "$_url/fuentes";
    final resp = await http.post(url, body: fuenteToJson(fuente));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }
}
