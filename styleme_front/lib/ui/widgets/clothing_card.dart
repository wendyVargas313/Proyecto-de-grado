import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';

/// Card para mostrar una prenda
class ClothingCard extends StatelessWidget {
  final ClothingModel clothing;
  final VoidCallback? onTap;
  final bool showFavorite;

  const ClothingCard({
    super.key,
    required this.clothing,
    this.onTap,
    this.showFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
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
                              errorWidget: (context, url, error) => const Icon(
                                Icons.checkroom,
                                size: 48,
                                color: AppColors.grey,
                              ),
                            )
                          : const Icon(
                              Icons.checkroom,
                              size: 48,
                              color: AppColors.grey,
                            ),
                    ),
                  ),
                  
                  // Favorito
                  if (showFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  
                  // Confianza
                  if (clothing.confianza != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(double.parse(clothing.confianza!) * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Información
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clothing.tipo,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getColorFromName(clothing.color),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: clothing.color == 'blanco'
                                ? Colors.grey
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          clothing.color,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}
