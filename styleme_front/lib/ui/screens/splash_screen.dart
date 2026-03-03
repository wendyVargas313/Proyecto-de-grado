import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../services/storage_service.dart';

/// Pantalla de Splash/Bienvenida
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Esperar 3 segundos
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Verificar si ya completó onboarding
    final onboardingCompleted = StorageService.isOnboardingCompleted();
    final isLoggedIn = StorageService.isLoggedIn();

    if (isLoggedIn) {
      // Ir a home
      Navigator.pushReplacementNamed(context, '/home');
    } else if (onboardingCompleted) {
      // Ir a login
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // Ir a onboarding
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authGradient,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Logo/Imagen de fondo (placeholder)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.checkroom,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Título
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Slogan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    AppConstants.appSlogan,
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const Spacer(),
                
                // Indicador de carga
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
