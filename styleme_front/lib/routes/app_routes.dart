import 'package:flutter/material.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/register_screen.dart';
import '../ui/screens/configure_profile_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/wardrobe_screen.dart';
import '../ui/screens/recommendations_screen.dart';
import '../ui/screens/profile_screen.dart';
import '../ui/screens/camera_screen.dart';

/// Rutas de la aplicación
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String configureProfile = '/configure-profile';
  static const String home = '/home';
  static const String wardrobe = '/wardrobe';
  static const String recommendations = '/recommendations';
  static const String profile = '/profile';
  static const String camera = '/camera';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        configureProfile: (context) => const ConfigureProfileScreen(),
        home: (context) => const HomeScreen(),
        wardrobe: (context) => const WardrobeScreen(),
        recommendations: (context) => const RecommendationsScreen(),
        profile: (context) => const ProfileScreen(),
        camera: (context) => const CameraScreen(),
      };
}
