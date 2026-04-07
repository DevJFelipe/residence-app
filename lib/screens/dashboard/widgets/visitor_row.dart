import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class VisitorRow extends StatelessWidget {
  final String name;
  final String destination;
  final String time;
  final String type;
  final Color typeBgColor;
  final Color typeTextColor;
  final bool showTopBorder;

  const VisitorRow({
    super.key,
    required this.name,
    required this.destination,
    required this.time,
    required this.type,
    required this.typeBgColor,
    required this.typeTextColor,
    this.showTopBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showTopBorder
          ? const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.borderLight),
              ),
            )
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Avatar + Name
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.avatarPlaceholder,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    name,
                    style: AppTextStyles.medium14,
                  ),
                ),
              ],
            ),
          ),
          // Destination
          Expanded(
            flex: 2,
            child: Text(
              destination,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ),
          // Time
          Expanded(
            flex: 2,
            child: Text(
              time,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Type badge
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeBgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type,
                  style: AppTextStyles.bold10.copyWith(color: typeTextColor),
                ),
              ),
            ),
          ),
          // Action
          GestureDetector(
            onTap: () {},
            child: Text(
              'Marcar\nSalida',
              style: AppTextStyles.bold14.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
