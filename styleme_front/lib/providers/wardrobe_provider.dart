import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Provider para gestión del guardarropa
class WardrobeProvider with ChangeNotifier {
  List<ClothingModel> _wardrobe = [];
  List<ClothingModel> _filteredWardrobe = [];
  String? _selectedType;
  String? _selectedColor;
  String? _selectedSeason;

  List<ClothingModel> get wardrobe => _filteredWardrobe.isEmpty && !hasFilters
      ? _wardrobe
      : _filteredWardrobe;
  String? get selectedType => _selectedType;
  String? get selectedColor => _selectedColor;
  String? get selectedSeason => _selectedSeason;
  bool get hasFilters =>
      _selectedType != null || _selectedColor != null || _selectedSeason != null;

  /// Cargar guardarropa
  void loadWardrobe(List<ClothingModel> clothes) {
    _wardrobe = clothes;
    _applyFilters();
    notifyListeners();
  }

  /// Agregar prenda
  void addClothing(ClothingModel clothing) {
    _wardrobe.add(clothing);
    _applyFilters();
    notifyListeners();
  }

  /// Filtrar por tipo
  void filterByType(String? type) {
    _selectedType = type;
    _applyFilters();
    notifyListeners();
  }

  /// Filtrar por color
  void filterByColor(String? color) {
    _selectedColor = color;
    _applyFilters();
    notifyListeners();
  }

  /// Filtrar por temporada
  void filterBySeason(String? season) {
    _selectedSeason = season;
    _applyFilters();
    notifyListeners();
  }

  /// Limpiar filtros
  void clearFilters() {
    _selectedType = null;
    _selectedColor = null;
    _selectedSeason = null;
    _applyFilters();
    notifyListeners();
  }

  /// Aplicar filtros
  void _applyFilters() {
    _filteredWardrobe = _wardrobe.where((clothing) {
      bool matchesType = _selectedType == null || clothing.tipo == _selectedType;
      bool matchesColor =
          _selectedColor == null || clothing.color == _selectedColor;
      bool matchesSeason =
          _selectedSeason == null || clothing.temporada == _selectedSeason;
      return matchesType && matchesColor && matchesSeason;
    }).toList();
  }

  /// Obtener tipos únicos
  List<String> getUniqueTypes() {
    return _wardrobe.map((c) => c.tipo).toSet().toList()..sort();
  }

  /// Obtener colores únicos
  List<String> getUniqueColors() {
    return _wardrobe.map((c) => c.color).toSet().toList()..sort();
  }

  /// Obtener temporadas únicas
  List<String> getUniqueSeasons() {
    return _wardrobe.map((c) => c.temporada).toSet().toList()..sort();
  }
}
