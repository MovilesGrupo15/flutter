import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recycling_point_model.dart';

class RecyclingRepository {
  // API URL
  final String _baseUrl = "http://192.168.1.43:8000"; // IP Local si es fisico

  Future<List<RecyclingPoint>> getRecyclingPoints() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/api/points"));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RecyclingPoint.fromJson(json)).toList();
      } else {
        throw Exception("Error al obtener los puntos: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}
