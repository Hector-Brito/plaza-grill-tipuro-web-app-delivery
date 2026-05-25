import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSheetService {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.appsheet.com/api/v2/apps";

  String get _appId => dotenv.env['APPSHEET_APP_ID'] ?? '';
  String get _accessKey => dotenv.env['APPSHEET_ACCESS_KEY'] ?? '';

  Future<List<dynamic>> _getTable(
    String tableName, {
    bool forceRefresh = false,
  }) async {
    if (_appId.isEmpty || _accessKey.isEmpty) {
      throw Exception("AppSheet credentials are not configured in .env");
    }

    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'appsheet_cache_$tableName';
    final timestampKey = 'appsheet_timestamp_$tableName';

    // Check cache first
    if (!forceRefresh) {
      final cachedData = prefs.getString(cacheKey);
      final cachedTimestampStr = prefs.getString(timestampKey);

      if (cachedData != null && cachedTimestampStr != null) {
        final cachedTimestamp = DateTime.parse(cachedTimestampStr);
        final now = DateTime.now();
        // Usa la caché solo si tiene menos de 5 minutos de antigüedad
        if (now.difference(cachedTimestamp).inMinutes < 5) {
          return jsonDecode(cachedData) as List<dynamic>;
        }
      }
    }

    final url = "$_baseUrl/$_appId/tables/$tableName/Action";

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            "ApplicationAccessKey": _accessKey,
            "Content-Type": "application/json",
          },
        ),
        data: {
          "Action": "Find",
          "Properties": {"Locale": "es-VE", "Timezone": "America/Caracas"},
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;

        // Save to cache
        await prefs.setString(cacheKey, jsonEncode(data));
        await prefs.setString(timestampKey, DateTime.now().toIso8601String());

        return data;
      } else {
        throw Exception(
          "Failed to load table $tableName: ${response.statusCode}",
        );
      }
    } catch (e) {
      // Fallback to stale cache if API fails
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        print("API failed, using stale cache for $tableName");
        return jsonDecode(cachedData) as List<dynamic>;
      }
      print("Error fetching AppSheet table $tableName: $e");
      rethrow;
    }
  }

  Future<List<dynamic>> getMenu({bool forceRefresh = false}) async {
    try {
      return await _getTable("CATMenu", forceRefresh: forceRefresh);
    } catch (e) {
      throw Exception("Error al cargar el Menú Principal: $e");
    }
  }

  Future<List<dynamic>> getCustomizations({bool forceRefresh = false}) async {
    try {
      return await _getTable("CATPersonalizacion", forceRefresh: forceRefresh);
    } catch (e) {
      throw Exception(
        "Error al cargar las personalizaciones (ingredientes extraíbles): $e",
      );
    }
  }

  Future<List<dynamic>> getExtras({bool forceRefresh = false}) async {
    try {
      return await _getTable("CATMenuAdicional", forceRefresh: forceRefresh);
    } catch (e) {
      throw Exception("Error al cargar los productos adicionales/extras: $e");
    }
  }

  Future<List<dynamic>> getProteins({bool forceRefresh = false}) async {
    try {
      return await _getTable("CATMenuProteina", forceRefresh: forceRefresh);
    } catch (e) {
      throw Exception("Error al cargar las proteínas: $e");
    }
  }

  Future<List<dynamic>> getBeverageFlavors({bool forceRefresh = false}) async {
    try {
      return await _getTable(
        "CATMenuBebidasSabores",
        forceRefresh: forceRefresh,
      );
    } catch (e) {
      throw Exception("Error al cargar los sabores de bebidas: $e");
    }
  }
}
