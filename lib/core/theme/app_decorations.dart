import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration premiumCard({
    Color? color,
    double radius = 16,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.cardBackground,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.borderSubtle),
      boxShadow: const [
        BoxShadow(
          color: AppColors.shadowPremium,
          blurRadius: 24,
          offset: Offset(0, 12),
          spreadRadius: -8,
        ),
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    );
  }

  static BoxDecoration iconTile({Color? tint, double radius = 12}) {
    return BoxDecoration(
      color: (tint ?? AppColors.primary).withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
