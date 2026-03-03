import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/user_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/selection_chip.dart';

/// Pantalla de Configuración de Perfil (3 pasos)
class ConfigureProfileScreen extends StatefulWidget {
  const ConfigureProfileScreen({super.key});

  @override
  State<ConfigureProfileScreen> createState() => _ConfigureProfileScreenState();
}

class _ConfigureProfileScreenState extends State<ConfigureProfileScreen> {
  int _currentStep = 0;
  final List<String> _selectedTypes = [];
  final List<String> _selectedColors = [];
  final List<String> _selectedSeasons = [];

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _finishConfiguration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _finishConfiguration() async {
    final userProvider = context.read<UserProvider>();
    
    userProvider.updatePreferences(
      types: _selectedTypes,
      colors: _selectedColors,
      seasons: _selectedSeasons,
    );

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _toggleSelection(List<String> list, String item) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else {
        list.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.header,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: _previousStep,
              )
            : null,
        title: Text(
          'Configurar tu perfil',
          style: AppTextStyles.h3,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildStepContent(),
              ),
            ),

            // Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: CustomButton(
                text: _currentStep == 2 ? 'Finalizar' : 'Siguiente',
                onPressed: _nextStep,
                backgroundColor: AppColors.buttonOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Paso ${_currentStep + 1} de 3',
            style: AppTextStyles.subtitle.copyWith(
              color: AppColors.secondaryOrange,
            ),
          ),
          const SizedBox(width: 20),
          ...List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == _currentStep ? 40 : 12,
              height: 12,
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? AppColors.secondaryOrange
                    : AppColors.lightGrey,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  // Paso 1: Tipos de prenda
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Qué tipo de prendas\nusas más?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Selecciona tus favoritas',
          style: AppTextStyles.body.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.clothingTypes.map((type) {
            final isSelected = _selectedTypes.contains(type);
            return SelectionChip(
              label: type,
              isSelected: isSelected,
              onTap: () => _toggleSelection(_selectedTypes, type),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Paso 2: Colores
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Cuáles son tus\ncolores favoritos?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Selecciona los que más te gusten',
          style: AppTextStyles.body.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.colors.map((color) {
            final isSelected = _selectedColors.contains(color);
            return SelectionChip(
              label: color,
              isSelected: isSelected,
              onTap: () => _toggleSelection(_selectedColors, color),
              color: _getColorFromName(color),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Paso 3: Temporadas
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Para qué temporadas\nquieres outfits?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Selecciona las temporadas',
          style: AppTextStyles.body.copyWith(color: AppColors.grey),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.seasons.map((season) {
            final isSelected = _selectedSeasons.contains(season);
            return SelectionChip(
              label: season,
              isSelected: isSelected,
              onTap: () => _toggleSelection(_selectedSeasons, season),
              icon: _getSeasonIcon(season),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'azul':
        return Colors.blue;
      case 'negro':
        return Colors.black;
      case 'blanco':
        return Colors.white;
      case 'rojo':
        return Colors.red;
      case 'verde':
        return Colors.green;
      case 'amarillo':
        return Colors.yellow;
      case 'rosa':
        return Colors.pink;
      case 'gris':
        return Colors.grey;
      case 'beige':
        return const Color(0xFFF5F5DC);
      default:
        return AppColors.grey;
    }
  }

  IconData _getSeasonIcon(String season) {
    switch (season.toLowerCase()) {
      case 'verano':
        return Icons.wb_sunny;
      case 'invierno':
        return Icons.ac_unit;
      case 'primavera':
        return Icons.local_florist;
      case 'otoño':
        return Icons.eco;
      default:
        return Icons.calendar_today;
    }
  }
}
