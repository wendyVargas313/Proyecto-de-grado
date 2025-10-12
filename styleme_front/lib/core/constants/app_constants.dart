/// Constantes de la aplicación
class AppConstants {
  // API
  static const String baseUrl = 'http://localhost:8000/api';
  static const String detectClothingEndpoint = '/detect-clothing/';
  static const String recommendEndpoint = '/recommend/';
  static const String recommendAIEndpoint = '/recommend-outfit-ai/';
  static const String imagesEndpoint = '/images/';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Validaciones
  static const int maxImageSizeMB = 10;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png'];
  
  // Paginación
  static const int itemsPerPage = 20;
  
  // Shared Preferences Keys
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  
  // Categorías de prendas
  static const List<String> clothingTypes = [
    'camiseta',
    'pantalón',
    'zapatos',
    'blusa',
    'falda',
    'jeans',
    'suéter',
    'botas',
    'sandalias',
  ];
  
  // Colores
  static const List<String> colors = [
    'azul',
    'negro',
    'blanco',
    'rojo',
    'verde',
    'amarillo',
    'rosa',
    'gris',
    'beige',
  ];
  
  // Temporadas
  static const List<String> seasons = [
    'verano',
    'invierno',
    'primavera',
    'otoño',
  ];
  
  // Mensajes
  static const String appName = 'STYLEME';
  static const String appSlogan = 'Tu estilo, tus reglas, crea tu outfit perfecto';
}
