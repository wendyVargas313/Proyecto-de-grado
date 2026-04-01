import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await StorageService.getUser();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar usuario: ';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUser(UserModel user) async {
    _isLoading = true;
    notifyListeners();
    try {
      await StorageService.saveUser(user);
      _user = user;
      _error = null;
    } catch (e) {
      _error = 'Error al guardar usuario: ';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(UserModel user) async {
    _user = user;
    await StorageService.saveUser(user);
    notifyListeners();
  }

  Future<void> addClothing(ClothingModel clothing) async {
    if (_user != null) {
      final updatedWardrobe = List<ClothingModel>.from(_user!.guardarropa)
        ..add(clothing);
      _user = _user!.copyWith(guardarropa: updatedWardrobe);
      await StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  Future<void> addMultipleClothing(List<ClothingModel> clothes) async {
    if (_user != null) {
      final updatedWardrobe = List<ClothingModel>.from(_user!.guardarropa)
        ..addAll(clothes);
      _user = _user!.copyWith(guardarropa: updatedWardrobe);
      await StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  Future<void> addOutfit(OutfitModel outfit) async {
    if (_user != null) {
      final updatedOutfits = List<OutfitModel>.from(_user!.outfitsGenerados)
        ..add(outfit);
      _user = _user!.copyWith(outfitsGenerados: updatedOutfits);
      await StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  Future<void> updatePreferences({
    List<String>? colors,
    List<String>? types,
    List<String>? seasons,
  }) async {
    if (_user != null) {
      _user = _user!.copyWith(
        preferenciasColor: colors ?? _user!.preferenciasColor,
        preferenciasTipo: types ?? _user!.preferenciasTipo,
        preferenciasTemporada: seasons ?? _user!.preferenciasTemporada,
      );
      await StorageService.saveUser(_user!);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await StorageService.logout();
    _user = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
