import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Servicio para comunicación con el backend
class ApiService {
  static const String baseUrl = AppConstants.baseUrl;

  /// Detectar prendas en una imagen
  Future<Map<String, dynamic>> detectClothing({
    required String email,
    required File imageFile,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl${AppConstants.detectClothingEndpoint}');
      var request = http.MultipartRequest('POST', uri);

      // Agregar email
      request.fields['email'] = email;

      // Agregar imagen
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Enviar request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al detectar prendas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Detectar múltiples prendas
  Future<Map<String, dynamic>> detectMultipleClothing({
    required String email,
    required List<File> imageFiles,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl${AppConstants.detectClothingEndpoint}');
      var request = http.MultipartRequest('POST', uri);

      // Agregar email
      request.fields['email'] = email;

      // Agregar imágenes
      for (var imageFile in imageFiles) {
        request.files.add(
          await http.MultipartFile.fromPath('images', imageFile.path),
        );
      }

      // Enviar request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al detectar prendas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Generar recomendaciones de outfits
  Future<Map<String, dynamic>> generateRecommendations({
    required String email,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl${AppConstants.recommendEndpoint}');
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al generar recomendaciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Predecir con IA
  Future<Map<String, dynamic>> predictOutfitAI({
    required Map<String, int> features,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl${AppConstants.recommendAIEndpoint}');
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(features),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al predecir outfit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener metadata de imagen
  Future<Map<String, dynamic>> getImageMetadata({
    required String imageId,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl${AppConstants.imagesEndpoint}$imageId/metadata');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener metadata: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Construir URL completa de imagen
  String getImageUrl(String imageId) {
    return '$baseUrl${AppConstants.imagesEndpoint}$imageId';
  }
}
