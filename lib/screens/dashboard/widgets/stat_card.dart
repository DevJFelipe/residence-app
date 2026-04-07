import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final String label;
  final String value;
  final String? changeText;
  final bool isPositive;

  const StatCard({
    super.key,
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
    required this.value,
    this.changeText,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: iconWidth,
                height: iconHeight,
              ),
              if (changeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? AppColors.successBackground
                        : AppColors.errorBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    changeText!,
                    style: AppTextStyles.badgeText.copyWith(
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.statLabel),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }
}
