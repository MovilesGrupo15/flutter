import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'route_history_model.dart';

class RouteHistoryService {
  static const _key = 'route_history';

  static Future<List<RouteHistory>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((item) => RouteHistory.fromJson(item)).toList();
  }

  static Future<void> addEntry(RouteHistory entry) async {
    final history = await getHistory();
    history.add(entry);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(history.map((e) => e.toJson()).toList()));
  }
}
