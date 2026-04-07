import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class QuickActionButton extends StatelessWidget {
  final String iconAsset;
  final double iconWidth;
  final double iconHeight;
  final String label;
  final bool isPrimary;
  final VoidCallback? onTap;

  const QuickActionButton({
    super.key,
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryExtraLight : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: isPrimary
              ? Border.all(color: AppColors.primaryBorder)
              : null,
        ),
        padding: const EdgeInsets.all(17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: iconWidth,
              height: iconHeight,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bold12.copyWith(
                color: isPrimary ? AppColors.primary : AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
