import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/user_provider.dart';

/// Pantalla de Perfil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          'Perfil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // TODO: Configuración
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Foto de perfil
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.secondaryOrange,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Nombre
                  Text(
                    user.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Email
                  Text(
                    user.correo,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Botón editar perfil
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Editar perfil
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 18,
                      color: AppColors.secondaryOrange,
                    ),
                    label: const Text(
                      'Editar perfil',
                      style: TextStyle(
                        color: AppColors.secondaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Estadísticas
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.checkroom,
                            count: user.guardarropa.length,
                            label: 'Prendas',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            icon: Icons.auto_awesome,
                            count: user.outfitsGenerados.length,
                            label: 'Outfits',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Preferencias
                  _buildSection(
                    title: 'Preferencias',
                    children: [
                      _buildPreferenceItem(
                        icon: Icons.palette,
                        title: 'Colores favoritos',
                        value: user.preferenciasColor.isEmpty
                            ? 'No configurado'
                            : user.preferenciasColor.join(', '),
                        onTap: () {
                          // TODO: Editar colores
                        },
                      ),
                      _buildPreferenceItem(
                        icon: Icons.checkroom,
                        title: 'Tipos de prenda',
                        value: user.preferenciasTipo.isEmpty
                            ? 'No configurado'
                            : user.preferenciasTipo.join(', '),
                        onTap: () {
                          // TODO: Editar tipos
                        },
                      ),
                      _buildPreferenceItem(
                        icon: Icons.wb_sunny,
                        title: 'Temporadas',
                        value: user.preferenciasTemporada.isEmpty
                            ? 'No configurado'
                            : user.preferenciasTemporada.join(', '),
                        onTap: () {
                          // TODO: Editar temporadas
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Opciones
                  _buildSection(
                    title: 'Opciones',
                    children: [
                      _buildMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notificaciones',
                        onTap: () {
                          // TODO: Notificaciones
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Ayuda',
                        onTap: () {
                          // TODO: Ayuda
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'Acerca de',
                        onTap: () {
                          // TODO: Acerca de
                        },
                      ),
                      _buildMenuItem(
                        icon: Icons.logout,
                        title: 'Cerrar sesión',
                        textColor: AppColors.error,
                        onTap: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required int count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.secondaryOrange,
          ),
          const SizedBox(height: 12),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondaryOrange),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.grey,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppColors.secondaryOrange,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: textColor ?? AppColors.grey,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<UserProvider>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
