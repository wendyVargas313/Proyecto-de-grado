import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../services/storage_service.dart';

/// Pantalla de Onboarding
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Diseña tu atuendo\nperfecto en segundos',
      description: 'Crea combinaciones únicas con tu guardarropa',
      icon: Icons.checkroom,
    ),
    OnboardingPage(
      title: 'Captura tus prendas\nfácilmente',
      description: 'Toma fotos y detecta automáticamente tus prendas',
      icon: Icons.camera_alt,
    ),
    OnboardingPage(
      title: 'Recibe recomendaciones\npersonalizadas',
      description: 'IA que aprende tu estilo y te sugiere outfits',
      icon: Icons.auto_awesome,
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onGetStarted() async {
    await StorageService.setOnboardingCompleted(true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _onSkip() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (_currentPage < _pages.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onSkip,
                  child: const Text(
                    'Saltar',
                    style: TextStyle(
                      color: AppColors.secondaryOrange,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 48),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: _pages.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.secondaryOrange,
                dotColor: AppColors.lightGrey,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            ),

            const SizedBox(height: 40),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _currentPage == _pages.length - 1
                      ? _onGetStarted
                      : () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Comenzar' : 'Siguiente',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.buttonOrange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: AppColors.secondaryOrange,
            ),
          ),

          const SizedBox(height: 60),

          // Title
          Text(
            page.title,
            style: AppTextStyles.h2Dark,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            style: AppTextStyles.body.copyWith(
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}
