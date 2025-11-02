import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';

/// Card para mostrar un outfit completo
class OutfitCard extends StatelessWidget {
  final OutfitModel outfit;
  final VoidCallback? onTap;
  final bool showDeleteButton;
  final VoidCallback? onDelete;

  const OutfitCard({
    super.key,
    required this.outfit,
    this.onTap,
    this.showDeleteButton = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      outfit.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showDeleteButton)
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          onPressed: onDelete,
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: AppColors.grey,
                        ),
                        onPressed: () {
                          // TODO: Marcar como favorito
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Prendas
            Expanded(
              child: outfit.prendas.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin prendas',
                        style: TextStyle(color: AppColors.grey),
                      ),
                    )
                  : outfit.prendas.length == 1
                      ? _buildSingleClothing(outfit.prendas[0])
                      : outfit.prendas.length == 2
                          ? _buildTwoClothes(outfit.prendas)
                          : _buildThreeClothes(outfit.prendas),
            ),

            // Acciones
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Ver alternativas
                      },
                      icon: const Icon(Icons.swap_horiz),
                      label: const Text('Alternativas'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondaryOrange,
                        side: const BorderSide(
                          color: AppColors.secondaryOrange,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Compartir outfit
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Compartir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleClothing(ClothingModel clothing) {
    return Center(
      child: _buildClothingImage(clothing, width: 200, height: 200),
    );
  }

  Widget _buildTwoClothes(List<ClothingModel> clothes) {
    return Row(
      children: [
        Expanded(
          child: _buildClothingImage(clothes[0]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildClothingImage(clothes[1]),
        ),
      ],
    );
  }

  Widget _buildThreeClothes(List<ClothingModel> clothes) {
    return Row(
      children: [
        Expanded(
          child: _buildClothingImage(clothes[0]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: _buildClothingImage(clothes[1]),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _buildClothingImage(
                  clothes.length > 2 ? clothes[2] : clothes[1],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClothingImage(
    ClothingModel clothing, {
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: clothing.imagenUrl != null
            ? CachedNetworkImage(
                imageUrl: clothing.fullImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.secondaryOrange,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.checkroom,
                      size: 40,
                      color: AppColors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      clothing.tipo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.checkroom,
                    size: 40,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    clothing.tipo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
