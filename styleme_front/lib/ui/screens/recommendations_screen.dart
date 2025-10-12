import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../services/api_service.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
import '../widgets/outfit_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/custom_button.dart';

/// Pantalla de Recomendaciones
class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final ApiService _apiService = ApiService();
  final PageController _pageController = PageController();
  List<OutfitModel> _outfits = [];
  bool _isLoading = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final user = context.read<UserProvider>().user;
    if (user == null) return;

    // Cargar outfits guardados
    setState(() {
      _outfits = user.outfitsGenerados;
    });

    // Si no hay outfits, generar automáticamente
    if (_outfits.isEmpty && user.guardarropa.isNotEmpty) {
      _generateOutfits();
    }
  }

  Future<void> _generateOutfits() async {
    final user = context.read<UserProvider>().user;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.generateRecommendations(
        email: user.correo,
      );

      if (response['success'] == true) {
        final outfits = (response['outfits'] as List)
            .map((o) => OutfitModel.fromJson(o))
            .toList();

        setState(() {
          _outfits = outfits;
        });

        // Guardar en el provider
        if (mounted) {
          for (var outfit in outfits) {
            context.read<UserProvider>().addOutfit(outfit);
          }
        }

        _showSuccess('¡Nuevos outfits generados!');
      } else {
        _showError(response['error'] ?? 'Error al generar outfits');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.header,
        elevation: 0,
        title: const Text(
          'STYLEME',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Notificaciones
            },
          ),
        ],
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(user),
      ),
    );
  }

  Widget _buildContent(UserModel user) {
    if (user.guardarropa.isEmpty) {
      return EmptyState(
        icon: Icons.checkroom_outlined,
        message: 'Agrega prendas primero',
        description: 'Necesitas prendas en tu guardarropa para generar outfits',
        actionText: 'Agregar prendas',
        onAction: () {
          // Cambiar a tab de cámara
        },
      );
    }

    if (_outfits.isEmpty && !_isLoading) {
      return EmptyState(
        icon: Icons.auto_awesome_outlined,
        message: 'Sin recomendaciones',
        description: 'Genera outfits personalizados con IA',
        actionText: 'Generar outfits',
        onAction: _generateOutfits,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saludo
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, ${user.nombre}!',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu combinación ideal',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),

        // Outfits
        if (_isLoading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.secondaryOrange,
                ),
              ),
            ),
          )
        else
          Expanded(
            child: Column(
              children: [
                // Carrusel de outfits
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: _outfits.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: OutfitCard(
                          outfit: _outfits[index],
                          onTap: () {
                            // TODO: Ver detalles del outfit
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Indicador de página
                if (_outfits.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_outfits.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == _currentPage ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == _currentPage
                                ? AppColors.secondaryOrange
                                : AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),

                // Botón generar nuevo
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: CustomButton(
                    text: 'Generar nuevo outfit',
                    icon: Icons.refresh,
                    onPressed: _isLoading ? null : _generateOutfits,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
