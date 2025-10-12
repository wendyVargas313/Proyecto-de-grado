import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../services/api_service.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
import '../widgets/custom_button.dart';

/// Pantalla de Cámara para capturar prendas
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();
  File? _selectedImage;
  bool _isProcessing = false;
  List<ClothingModel>? _detectedClothes;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _detectedClothes = null;
        });
      }
    } catch (e) {
      _showError('Error al seleccionar imagen: $e');
    }
  }

  Future<void> _detectClothing() async {
    if (_selectedImage == null) return;

    final user = context.read<UserProvider>().user;
    if (user == null) {
      _showError('Usuario no encontrado');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final response = await _apiService.detectClothing(
        email: user.correo,
        imageFile: _selectedImage!,
      );

      if (response['success'] == true) {
        final prendas = (response['prendas'] as List)
            .map((p) => ClothingModel.fromJson(p))
            .toList();

        setState(() {
          _detectedClothes = prendas;
        });

        // Agregar al guardarropa del usuario
        if (mounted) {
          context.read<UserProvider>().addMultipleClothing(prendas);
        }

        _showSuccess('¡Prendas detectadas y guardadas!');
      } else {
        _showError(response['error'] ?? 'Error al detectar prendas');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      setState(() => _isProcessing = false);
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

  void _reset() {
    setState(() {
      _selectedImage = null;
      _detectedClothes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.header,
        elevation: 0,
        title: const Text(
          'Agregar Prenda',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: _reset,
            ),
        ],
      ),
      body: SafeArea(
        child: _selectedImage == null
            ? _buildImageSelection()
            : _buildImagePreview(),
      ),
    );
  }

  Widget _buildImageSelection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 70,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Captura o selecciona\nuna prenda',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Detectaremos automáticamente\nel tipo de prenda',
              style: AppTextStyles.body.copyWith(
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            CustomButton(
              text: 'Tomar foto',
              icon: Icons.camera_alt,
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Seleccionar de galería',
              icon: Icons.photo_library,
              onPressed: () => _pickImage(ImageSource.gallery),
              backgroundColor: Colors.white,
              textColor: AppColors.secondaryOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Imagen
          Container(
            width: double.infinity,
            height: 400,
            color: Colors.black,
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 24),

          // Resultados de detección
          if (_detectedClothes != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_detectedClothes!.length} prenda(s) detectada(s)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._detectedClothes!.map((clothing) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.checkroom,
                              color: AppColors.secondaryOrange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clothing.tipo,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Confianza: ${(double.parse(clothing.confianza ?? "0") * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomButton(
                text: 'Agregar otra prenda',
                onPressed: _reset,
              ),
            ),
          ] else ...[
            // Botón de detección
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'Detectar prenda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Usaremos IA para identificar el tipo de prenda',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Detectar',
                    icon: Icons.auto_awesome,
                    onPressed: _isProcessing ? null : _detectClothing,
                    isLoading: _isProcessing,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _reset,
                    child: const Text(
                      'Seleccionar otra imagen',
                      style: TextStyle(
                        color: AppColors.secondaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
