import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ecosnap/features/map/data/recycling_cache_service.dart';
import '../../../core/services/connectivity_provider.dart';
import 'recycling_point_model.dart';

class RecyclingRepository {
  final String _baseUrl = "https://ecosnap-back.onrender.com";

  /// Obtiene todos los puntos de reciclaje
  Future<List<RecyclingPoint>> getRecyclingPoints() async {
    try {
      final isOnline = await ConnectivityProvider.checkConnection();

      if (isOnline) {
        final response = await http.get(Uri.parse("$_baseUrl/api/points"));

        if (response.statusCode == 200) {
          // Usamos compute para parsear en un isolate
          final points = await compute(parseRecyclingPoints, response.body);

          // Guardamos en cache local
          await RecyclingCacheService.saveRecyclingPoints(points);

          return points;
        } else {
          throw Exception("Error al obtener los puntos: ${response.statusCode}");
        }
      } else {
        // Si está offline, carga desde Hive
        final cachedPoints = RecyclingCacheService.getRecyclingPoints();
        return cachedPoints;
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

// Función que corre en un isolate usando compute()
List<RecyclingPoint> parseRecyclingPoints(String responseBody) {
  final List<dynamic> data = jsonDecode(responseBody);
  return data.map((json) => RecyclingPoint.fromListJson(json)).toList();
}
