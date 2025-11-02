import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/user_provider.dart';
import '../widgets/outfit_card.dart';
import '../widgets/empty_state.dart';

/// Pantalla de Atuendos Guardados
class SavedOutfitsScreen extends StatelessWidget {
  const SavedOutfitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.header,
        elevation: 0,
        title: const Text(
          'Mis Atuendos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () {
              _showDeleteAllDialog(context);
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(context, user.outfitsGenerados),
    );
  }

  Widget _buildContent(BuildContext context, List outfits) {
    if (outfits.isEmpty) {
      return EmptyState(
        icon: Icons.checkroom_outlined,
        message: 'No tienes atuendos guardados',
        description: 'Genera y guarda tus combinaciones favoritas',
        actionText: 'Generar atuendos',
        onAction: () {
          // Navegar a la pantalla de recomendaciones
          DefaultTabController.of(context)?.animateTo(0);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Contador
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.checkroom,
                      size: 20,
                      color: AppColors.secondaryOrange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${outfits.length} ${outfits.length == 1 ? 'atuendo' : 'atuendos'}',
                      style: const TextStyle(
                        color: AppColors.secondaryOrange,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  _showSortOptions(context);
                },
                icon: const Icon(
                  Icons.sort,
                  size: 20,
                  color: AppColors.secondaryOrange,
                ),
                label: const Text(
                  'Ordenar',
                  style: TextStyle(
                    color: AppColors.secondaryOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Grid de outfits
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 0.85,
              mainAxisSpacing: 20,
            ),
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              return OutfitCard(
                outfit: outfits[index],
                onTap: () {
                  _showOutfitDetails(context, outfits[index]);
                },
                showDeleteButton: true,
                onDelete: () {
                  _showDeleteDialog(context, index);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showOutfitDetails(BuildContext context, outfit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  outfit.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Prendas en este atuendo:',
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 12),
            ...outfit.prendas.map((prenda) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.checkroom,
                      color: AppColors.secondaryOrange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prenda.tipo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${prenda.color} • ${prenda.temporada}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Compartir
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Compartir'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondaryOrange,
                      side: const BorderSide(
                        color: AppColors.secondaryOrange,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Editar
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar atuendo'),
        content: const Text('¿Estás seguro de que quieres eliminar este atuendo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Eliminar outfit del provider
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Atuendo eliminado'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    final user = context.read<UserProvider>().user;
    if (user == null || user.outfitsGenerados.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar todos'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los atuendos guardados?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Eliminar todos los outfits
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos los atuendos eliminados'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Eliminar todos',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ordenar por',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.access_time, color: AppColors.secondaryOrange),
              title: const Text('Más recientes'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Ordenar por fecha
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: AppColors.secondaryOrange),
              title: const Text('Favoritos'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Ordenar por favoritos
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha, color: AppColors.secondaryOrange),
              title: const Text('Nombre'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Ordenar por nombre
              },
            ),
          ],
        ),
      ),
    );
  }
}
