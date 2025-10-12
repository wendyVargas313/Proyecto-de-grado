import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Estilos de texto de la aplicación
class AppTextStyles {
  // Títulos grandes
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  
  static const TextStyle h1Dark = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  // Títulos medianos
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  
  static const TextStyle h2Dark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );
  
  // Títulos pequeños
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  
  // Subtítulos
  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  
  static const TextStyle subtitleDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );
  
  // Cuerpo de texto
  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );
  
  static const TextStyle bodyLight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );
  
  // Texto pequeño
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );
  
  // Botones
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );
  
  // Links
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryOrange,
    decoration: TextDecoration.underline,
  );
}
