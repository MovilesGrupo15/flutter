// lib/features/map/data/recycling_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recycling_point_model.dart';

class RecyclingRepository {
  final String _baseUrl = "http://172.20.10.6:8000"; // Tu IP pública

  /// Obtiene todos los puntos de reciclaje
  Future<List<RecyclingPoint>> getRecyclingPoints() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/api/points"));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RecyclingPoint.fromListJson(json)).toList();
      } else {
        throw Exception("Error al obtener los puntos: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  /// Obtiene el detalle completo de un punto de reciclaje
  Future<RecyclingPoint> getRecyclingPointDetail(String id) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/api/points/$id"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return RecyclingPoint.fromDetailJson(data);
      } else {
        throw Exception("Error al obtener detalle: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}
