import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Servicio para almacenamiento local
class StorageService {
  static SharedPreferences? _prefs;

  /// Inicializar SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Guardar email del usuario
  static Future<bool> saveUserEmail(String email) async {
    return await _prefs?.setString(AppConstants.keyUserEmail, email) ?? false;
  }

  /// Obtener email del usuario
  static String? getUserEmail() {
    return _prefs?.getString(AppConstants.keyUserEmail);
  }

  /// Guardar nombre del usuario
  static Future<bool> saveUserName(String name) async {
    return await _prefs?.setString(AppConstants.keyUserName, name) ?? false;
  }

  /// Obtener nombre del usuario
  static String? getUserName() {
    return _prefs?.getString(AppConstants.keyUserName);
  }

  /// Marcar como logueado
  static Future<bool> setLoggedIn(bool value) async {
    return await _prefs?.setBool(AppConstants.keyIsLoggedIn, value) ?? false;
  }

  /// Verificar si está logueado
  static bool isLoggedIn() {
    return _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  /// Marcar onboarding como completado
  static Future<bool> setOnboardingCompleted(bool value) async {
    return await _prefs?.setBool(AppConstants.keyOnboardingCompleted, value) ?? false;
  }

  /// Verificar si onboarding está completado
  static bool isOnboardingCompleted() {
    return _prefs?.getBool(AppConstants.keyOnboardingCompleted) ?? false;
  }

  /// Guardar usuario completo
  static Future<bool> saveUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    final emailSaved = await saveUserEmail(user.correo);
    final nameSaved = await saveUserName(user.nombre);
    final userSaved = await _prefs?.setString('user_data', userJson) ?? false;
    return emailSaved && nameSaved && userSaved;
  }

  /// Obtener usuario guardado
  static UserModel? getUser() {
    final userJson = _prefs?.getString('user_data');
    if (userJson != null) {
      return UserModel.fromJson(json.decode(userJson));
    }
    return null;
  }

  /// Cerrar sesión (limpiar datos)
  static Future<bool> logout() async {
    return await _prefs?.clear() ?? false;
  }
}
