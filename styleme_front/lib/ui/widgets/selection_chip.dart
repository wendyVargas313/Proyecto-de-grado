import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Chip de selección personalizado
class SelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon;

  const SelectionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryOrange : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.secondaryOrange : AppColors.lightGrey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color == Colors.white ? Colors.grey : Colors.transparent,
                    width: 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : AppColors.grey,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
