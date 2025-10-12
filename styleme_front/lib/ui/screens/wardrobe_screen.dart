import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/user_provider.dart';
import '../../providers/wardrobe_provider.dart';
import '../widgets/clothing_card.dart';
import '../widgets/empty_state.dart';

/// Pantalla de Guardarropa
class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  void initState() {
    super.initState();
    _loadWardrobe();
  }

  void _loadWardrobe() {
    final user = context.read<UserProvider>().user;
    if (user != null) {
      context.read<WardrobeProvider>().loadWardrobe(user.guardarropa);
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFiltersSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.header,
        elevation: 0,
        title: const Text(
          'Guardarropa',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // TODO: Implementar búsqueda
            },
          ),
        ],
      ),
      body: Consumer<WardrobeProvider>(
        builder: (context, wardrobeProvider, child) {
          final wardrobe = wardrobeProvider.wardrobe;

          if (wardrobe.isEmpty) {
            return EmptyState(
              icon: Icons.checkroom_outlined,
              message: 'Tu guardarropa está vacío',
              description: 'Agrega prendas usando la cámara',
              actionText: 'Agregar prenda',
              onAction: () {
                // Cambiar a tab de cámara
                final homeState = context.findAncestorStateOfType<State>();
                if (homeState != null && homeState.mounted) {
                  // Navegar a cámara
                }
              },
            );
          }

          return Column(
            children: [
              // Filtros activos
              if (wardrobeProvider.hasFilters)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Text(
                        'Filtros activos:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              if (wardrobeProvider.selectedType != null)
                                _buildFilterChip(
                                  wardrobeProvider.selectedType!,
                                  () => wardrobeProvider.filterByType(null),
                                ),
                              if (wardrobeProvider.selectedColor != null)
                                _buildFilterChip(
                                  wardrobeProvider.selectedColor!,
                                  () => wardrobeProvider.filterByColor(null),
                                ),
                              if (wardrobeProvider.selectedSeason != null)
                                _buildFilterChip(
                                  wardrobeProvider.selectedSeason!,
                                  () => wardrobeProvider.filterBySeason(null),
                                ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => wardrobeProvider.clearFilters(),
                        child: const Text('Limpiar'),
                      ),
                    ],
                  ),
                ),

              // Grid de prendas
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: wardrobe.length,
                  itemBuilder: (context, index) {
                    return ClothingCard(
                      clothing: wardrobe[index],
                      onTap: () {
                        // TODO: Navegar a detalle
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSheet() {
    return Consumer<WardrobeProvider>(
      builder: (context, wardrobeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtros',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      wardrobeProvider.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Limpiar'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tipo
              const Text(
                'Tipo de prenda',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: wardrobeProvider.getUniqueTypes().map((type) {
                  final isSelected = wardrobeProvider.selectedType == type;
                  return FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      wardrobeProvider.filterByType(selected ? type : null);
                    },
                    selectedColor: AppColors.secondaryOrange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Color
              const Text(
                'Color',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: wardrobeProvider.getUniqueColors().map((color) {
                  final isSelected = wardrobeProvider.selectedColor == color;
                  return FilterChip(
                    label: Text(color),
                    selected: isSelected,
                    onSelected: (selected) {
                      wardrobeProvider.filterByColor(selected ? color : null);
                    },
                    selectedColor: AppColors.secondaryOrange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Temporada
              const Text(
                'Temporada',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: wardrobeProvider.getUniqueSeasons().map((season) {
                  final isSelected = wardrobeProvider.selectedSeason == season;
                  return FilterChip(
                    label: Text(season),
                    selected: isSelected,
                    onSelected: (selected) {
                      wardrobeProvider.filterBySeason(selected ? season : null);
                    },
                    selectedColor: AppColors.secondaryOrange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonOrange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Aplicar filtros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
