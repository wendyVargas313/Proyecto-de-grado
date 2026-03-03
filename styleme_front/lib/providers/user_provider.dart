import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

/// Provider para gestión del usuario
class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  /// Cargar usuario desde storage
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = StorageService.getUser();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar usuario: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Guardar usuario
  Future<void> saveUser(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    try {
      await StorageService.saveUser(user);
      await StorageService.setLoggedIn(true);
      _user = user;
      _error = null;
    } catch (e) {
      _error = 'Error al guardar usuario: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualizar usuario
  void updateUser(UserModel user) {
    _user = user;
    StorageService.saveUser(user);
    notifyListeners();
  }

  /// Agregar prenda al guardarropa
  void addClothing(ClothingModel clothing) {
    if (_user != null) {
      final updatedWardrobe = List<ClothingModel>.from(_user!.guardarropa)
        ..add(clothing);
      _user = _user!.copyWith(guardarropa: updatedWardrobe);
      StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  /// Agregar múltiples prendas
  void addMultipleClothing(List<ClothingModel> clothes) {
    if (_user != null) {
      final updatedWardrobe = List<ClothingModel>.from(_user!.guardarropa)
        ..addAll(clothes);
      _user = _user!.copyWith(guardarropa: updatedWardrobe);
      StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  /// Agregar outfit generado
  void addOutfit(OutfitModel outfit) {
    if (_user != null) {
      final updatedOutfits = List<OutfitModel>.from(_user!.outfitsGenerados)
        ..add(outfit);
      _user = _user!.copyWith(outfitsGenerados: updatedOutfits);
      StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  /// Actualizar preferencias
  void updatePreferences({
    List<String>? colors,
    List<String>? types,
    List<String>? seasons,
  }) {
    if (_user != null) {
      _user = _user!.copyWith(
        preferenciasColor: colors ?? _user!.preferenciasColor,
        preferenciasTipo: types ?? _user!.preferenciasTipo,
        preferenciasTemporada: seasons ?? _user!.preferenciasTemporada,
      );
      StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    await StorageService.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
