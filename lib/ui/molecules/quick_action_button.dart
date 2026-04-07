import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residence_app/core/theme/app_colors.dart';
import 'package:residence_app/core/theme/app_spacing.dart';

/// A square quick-action tile with an SVG icon and
/// a short label beneath it.
///
/// When [isPrimary] is true, the tile uses a light
/// orange background with an orange border accent.
class QuickActionButton extends StatelessWidget {
  /// Path to an SVG icon asset.
  final String iconAsset;

  /// Width of the SVG icon.
  final double iconWidth;

  /// Height of the SVG icon.
  final double iconHeight;

  /// Short text label displayed below the icon.
  final String label;

  /// When true, applies a primary accent style.
  final bool isPrimary;

  /// Callback invoked when the tile is tapped.
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
          color: isPrimary
              ? AppColors.primaryExtraLight
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusMd,
          ),
          border: isPrimary
              ? Border.all(
                  color: AppColors.primaryBorder,
                )
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
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: GoogleFonts.publicSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 16 / 12,
                color: isPrimary
                    ? AppColors.primary
                    : AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
