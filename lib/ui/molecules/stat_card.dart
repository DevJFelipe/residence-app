import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';
import 'package:residence_app/core/theme/app_text_styles.dart';

/// A card displaying a single statistic with an icon,
/// label, value, and a change indicator badge.
///
/// Based on the dashboard stat card pattern. The
/// [changeText] is colored green or red depending on
/// [isPositive].
class StatCard extends StatelessWidget {
  /// Path to an SVG icon asset.
  final String iconAsset;

  /// Width of the SVG icon.
  final double iconWidth;

  /// Height of the SVG icon.
  final double iconHeight;

  /// Descriptive label shown below the icon.
  final String label;

  /// The main numeric or text value displayed
  /// prominently.
  final String value;

  /// Text for the change indicator badge,
  /// e.g. "+12%" or "-5%".
  final String changeText;

  /// Whether the change is positive (green) or
  /// negative (red).
  final bool isPositive;

  const StatCard({
    super.key,
    required this.iconAsset,
    required this.iconWidth,
    required this.iconHeight,
    required this.label,
    required this.value,
    required this.changeText,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: iconWidth,
                height: iconHeight,
              ),
              _buildChangeBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppTextStyles.statLabel),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }

  Widget _buildChangeBadge() {
    final bgColor = isPositive
        ? AppColors.successBackground
        : AppColors.errorBackground;
    final textColor = isPositive
        ? AppColors.success
        : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        changeText,
        style: GoogleFonts.publicSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 16 / 12,
          color: textColor,
        ),
      ),
    );
  }
}
