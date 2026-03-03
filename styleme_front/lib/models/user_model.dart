/// Modelo de Usuario
class UserModel {
  final String nombre;
  final String correo;
  final List<String> preferenciasColor;
  final List<String> preferenciasTipo;
  final List<String> preferenciasTemporada;
  final List<ClothingModel> guardarropa;
  final List<OutfitModel> outfitsGenerados;

  UserModel({
    required this.nombre,
    required this.correo,
    this.preferenciasColor = const [],
    this.preferenciasTipo = const [],
    this.preferenciasTemporada = const [],
    this.guardarropa = const [],
    this.outfitsGenerados = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      preferenciasColor: List<String>.from(json['preferencias_color'] ?? []),
      preferenciasTipo: List<String>.from(json['preferencias_tipo'] ?? []),
      preferenciasTemporada: List<String>.from(json['preferencias_temporada'] ?? []),
      guardarropa: (json['guardarropa'] as List?)
              ?.map((item) => ClothingModel.fromJson(item))
              .toList() ??
          [],
      outfitsGenerados: (json['outfits_generados'] as List?)
              ?.map((item) => OutfitModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'preferencias_color': preferenciasColor,
      'preferencias_tipo': preferenciasTipo,
      'preferencias_temporada': preferenciasTemporada,
      'guardarropa': guardarropa.map((item) => item.toJson()).toList(),
      'outfits_generados': outfitsGenerados.map((item) => item.toJson()).toList(),
    };
  }

  UserModel copyWith({
    String? nombre,
    String? correo,
    List<String>? preferenciasColor,
    List<String>? preferenciasTipo,
    List<String>? preferenciasTemporada,
    List<ClothingModel>? guardarropa,
    List<OutfitModel>? outfitsGenerados,
  }) {
    return UserModel(
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      preferenciasColor: preferenciasColor ?? this.preferenciasColor,
      preferenciasTipo: preferenciasTipo ?? this.preferenciasTipo,
      preferenciasTemporada: preferenciasTemporada ?? this.preferenciasTemporada,
      guardarropa: guardarropa ?? this.guardarropa,
      outfitsGenerados: outfitsGenerados ?? this.outfitsGenerados,
    );
  }
}

/// Modelo de Prenda
class ClothingModel {
  final String tipo;
  final String color;
  final String temporada;
  final String? imagenId;
  final String? imagenUrl;
  final DateTime? fechaAgregada;
  final String? confianza;

  ClothingModel({
    required this.tipo,
    required this.color,
    required this.temporada,
    this.imagenId,
    this.imagenUrl,
    this.fechaAgregada,
    this.confianza,
  });

  factory ClothingModel.fromJson(Map<String, dynamic> json) {
    return ClothingModel(
      tipo: json['tipo'] ?? '',
      color: json['color'] ?? 'desconocido',
      temporada: json['temporada'] ?? 'desconocido',
      imagenId: json['imagen_id'],
      imagenUrl: json['imagen_url'],
      fechaAgregada: json['fecha_agregada'] != null
          ? DateTime.parse(json['fecha_agregada'])
          : null,
      confianza: json['confianza'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'color': color,
      'temporada': temporada,
      'imagen_id': imagenId,
      'imagen_url': imagenUrl,
      'fecha_agregada': fechaAgregada?.toIso8601String(),
      'confianza': confianza,
    };
  }

  String get fullImageUrl {
    if (imagenUrl == null) return '';
    if (imagenUrl!.startsWith('http')) return imagenUrl!;
    return 'http://localhost:8000$imagenUrl';
  }
}

/// Modelo de Outfit
class OutfitModel {
  final String nombre;
  final List<ClothingModel> prendas;

  OutfitModel({
    required this.nombre,
    required this.prendas,
  });

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    return OutfitModel(
      nombre: json['nombre'] ?? 'Outfit',
      prendas: (json['prendas'] as List?)
              ?.map((item) => ClothingModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'prendas': prendas.map((item) => item.toJson()).toList(),
    };
  }
}
