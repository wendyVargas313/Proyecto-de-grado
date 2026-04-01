import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

/// Pantalla de splash que verifica autenticación
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _checkAuthentication();
  }

  /// Inicializa la animación del splash
  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  /// Verifica si hay un usuario autenticado y navega accordingly
  Future<void> _checkAuthentication() async {
    // Esperar a que termine la animación
    await Future.delayed(const Duration(seconds: 3));

    try {
      final authService = AuthService();
      final isAuth = await authService.isAuthenticated();

      if (mounted) {
        if (isAuth) {
          // Hay token, navegar a home
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // No hay token, navegar a login
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      // En caso de error, navegar a login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o imagen principal
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.style,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              // Nombre de la app
              const Text(
                'StyleMe',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              
              // Slogan
              Text(
                'Tu estilo, tu forma de vestir',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),
              
              // Indicador de carga
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
