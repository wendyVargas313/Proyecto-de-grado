import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _onboardingKey = 'onboarding_completed';

  static Future<void> init() async {}

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<void> saveUser(UserModel user) async {
    final map = {
      'nombre': user.nombre,
      'correo': user.correo,
      'preferencias_color': user.preferenciasColor,
      'preferencias_tipo': user.preferenciasTipo,
      'preferencias_temporada': user.preferenciasTemporada,
    };
    await _storage.write(key: _userKey, value: jsonEncode(map));
  }

  static Future<UserModel?> getUser() async {
    try {
      final userJson = await _storage.read(key: _userKey);
      if (userJson != null) {
        return UserModel.fromJson(
          jsonDecode(userJson) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    await _storage.write(key: _onboardingKey, value: value.toString());
  }

  static Future<bool> isOnboardingCompleted() async {
    final val = await _storage.read(key: _onboardingKey);
    return val == 'true';
  }


  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  static Future<void> setLoggedIn(bool value) async {
    if (!value) await logout();
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
