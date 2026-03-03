import 'package:flutter/material.dart';

/// Colores de la aplicación StyleMe
class AppColors {
  // Colores principales de autenticación
  static const Color primaryOrange = Color(0xFFAF9338);
  static const Color secondaryOrange = Color(0xFFE35B18);
  
  // Botones
  static const Color buttonOrange = Color(0xFFFFA75D);
  
  // Encabezado y navbar
  static const Color header = Color(0xFFECECEC);
  
  // Fondo
  static const Color background = Color(0xFFF5F5F5);
  
  // Colores adicionales
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF616161);
  
  // Colores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Gradientes
  static const LinearGradient authGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryOrange, secondaryOrange],
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [buttonOrange, secondaryOrange],
  );
}
